FROM jupyter/datascience-notebook:r-3.6.2

# Install shiny server +rstudio server + extrensions to use them inside jupyterhub
USER $NB_USER
RUN pip install --no-cache-dir nbgitpuller
USER root
RUN apt-get update && \
    curl --silent -L --fail https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.2.5033-amd64.deb > /tmp/rstudio.deb && \
    apt-get install -y /tmp/rstudio.deb && \
    rm /tmp/rstudio.deb && \
    apt-get clean &&  \
    curl --silent --location --fail https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.12.933-amd64.deb > /tmp/shiny.deb && \
    dpkg -i /tmp/shiny.deb && \
    rm /tmp/shiny.deb && \
    sed -i -e '/^R_LIBS_USER=/s/^/#/' /etc/R/Renviron && \
    echo "R_LIBS_USER=${R_LIBS_USER}" >> /etc/R/Renviron

USER ${NB_USER}
RUN pip install --no-cache-dir https://github.com/jupyterhub/jupyter-server-proxy/archive/7ac0125.zip && \
    pip install --no-cache-dir jupyter-rsession-proxy==1.0b6 && \
    jupyter serverextension enable jupyter_server_proxy --sys-prefix && \
    jupyter nbextension install --py jupyter_server_proxy --sys-prefix && \
    jupyter nbextension enable --py jupyter_server_proxy --sys-prefix && \
    R --quiet -e "chooseCRANmirror(31,graphics=F);install.packages('devtools')" && \
    R --quiet -e "devtools::install_github('IRkernel/IRkernel', ref='0.8.11')" && \
    R --quiet -e "IRkernel::installspec(prefix='$NB_PYTHON_PREFIX')" && \
    R --quiet -e "install.packages('https://cran.r-project.org/src/contrib/Archive/shiny/shiny_1.3.2.tar.gz', repos=NULL, type='source')" 

USER root    
RUN echo "options(repos = c(CRAN='https://mran.microsoft.com/snapshot/2019-04-10'), download.file.method = 'libcurl')" > /etc/R/Rprofile.site && \
    install -o ${NB_USER} -d /var/log/shiny-server && \
    install -o ${NB_USER} -d /var/lib/shiny-server && \
    install -o ${NB_USER}  /dev/null /var/log/shiny-server.log && \
    install -o ${NB_USER}  /dev/null /var/run/shiny-server.pid

# Install System Libraries
RUN apt-get update \
  && apt-get install -y apt-utils \
     software-properties-common \
     gnupg \
     zlib1g-dev \
     libxml2-dev \
     libgit2-dev \
     libpng-dev \
     libsodium-dev \
     libv8-dev \
     libgsl-dev \
     gsl-bin \
     libjpeg-dev \
     libpoppler-cpp-dev \
     libmysqlclient-dev



# Copy Config Files
ADD config_files /config_files
Run cp /config_files/shiny-server.conf /etc/shiny-server/


# Install MariaDB
RUN apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc' \
    && add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://mirrors.supportex.net/mariadb/repo/10.3/ubuntu bionic main'\
    && apt-get update \
    && apt-get install -y mariadb-server mariadb-client


USER root
# Install solr
Run apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9 \
    && echo "deb http://repos.azulsystems.com/debian stable main" | sudo tee /etc/apt/sources.list.d/zulu.list \
    && apt-get update \
    && apt -y install zulu-11 \
    && export JAVA_HOME=/usr/lib/jvm/zulu-11/ \
    && wget http://www-eu.apache.org/dist/lucene/solr/7.7.2/solr-7.7.2.tgz \
    && tar xzf solr-7.7.2.tgz solr-7.7.2/bin/install_solr_service.sh --strip-components=2 \
    && bash ./install_solr_service.sh solr-7.7.2.tgz \
    && cp -r /config_files/solr-1/logs /opt/logs \
    && cp -r /config_files/solr-1/store /store \
    && cp -r /config_files/solr-1/docker-entrypoint-initdb.d /docker-entrypoint-initdb.d

# Install spaCy and models for german and english
USER $NB_USER
RUN conda update -y conda \
    && conda install -y spacy \
    && python -m spacy download de \
    && python -m spacy download en 



# Install required R libraries using a pre-defined R-Script
USER root
RUN conda install -c conda-forge libv8
RUN apt install -y r-cran-curl
RUN conda install -c conda-forge r-pdftools
USER $NB_USER
RUN Rscript /config_files/install.R


# Get latest Version of LCM Shiny Application from github
RUN git clone https://github.com/ChristianKahmann/ilcm_Shiny \
    && mv ilcm_Shiny/ /home/jovyan/iLCM \
    && chmod -R 777 /home/jovyan/iLCM

USER root    
RUN /usr/bin/mysqld_safe --basedir=/usr & \
    sleep 3s \
    && mysql --user=root --password= < /config_files/init_iLCM.sql \
    && mysqladmin shutdown --password=ilcm


# make solr and maridb use directory in jovyan home
RUN mkdir /home/jovyan/iLCM/mysql/ && \
    cp -r /var/lib/mysql/* /home/jovyan/iLCM/mysql/ && \
    chown -R jovyan /home/jovyan/iLCM/mysql  && \ 
    mkdir /home/jovyan/iLCM/solr/ && \
    chown -R jovyan /home/jovyan/iLCM/solr \
    && cp /config_files/config_file.R /home/jovyan/iLCM/config_file.R


  
# Clean up
RUN cp /config_files/my.cnf /etc/mysql/my.cnf \
    && chmod -R 777 /var/lib/mysql \
    && chmod -R 777 /var/log/mysql \
    && chmod -R 777 /var/run/mysqld \
    && chown -R jovyan /opt/solr/ \
    && apt-get autoclean -y \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && conda clean -a -y \
    && rm /home/jovyan/install_solr_service.sh \
    && rm /home/jovyan/solr-7.7.2.tgz 

# Add Workshop Materials
COPY Workshop/ /home/jovyan/Workshop
RUN chmod -R 777 /home/jovyan/Workshop 
#
#    && cd /home/jovyan/Workshop \
#    && cat tempfile.part.00 tempfile.part.01 tempfile.part.02 > token_movies_56.csv \
#    && rm temp* 
 #   && mv movies.csv /home/jovyan/iLCM/data_import/unprocessed_data/ \
#    && mv meta_movies_56.csv /home/jovyan/iLCM/data_import/processed_data/ \
 #   && mv token_movies_56.csv /home/jovyan/iLCM/data_import/processed_data/ \
  #  && mv metameta_movies_56.csv /home/jovyan/iLCM/data_import/processed_data/ 


COPY docker-entrypoint.sh /
ENTRYPOINT ["sh", "/docker-entrypoint.sh"]


USER $NB_USER
