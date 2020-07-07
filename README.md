[![Binder](https://notebooks.gesis.org/binder/badge_logo.svg)](https://notebooks.gesis.org/binder/v2/gh/ChristianKahmann/LCM_Binderhub/master)

# iLCM Binderhub
Create a Jupyterhub instance with the iLCM Application integrated


# Tutorial

In this tutorial some movie plots from Wikipedia will be processed using the LCM.
The data basis is taken from [kaggle](https://www.kaggle.com/jrobischon/wikipedia-movie-plots)
This was then enriched with additional metadata from Wikipedia and subsequently filtered.

We will remove duplicate entries from this dataset and afterwards try to automatically determine topics in movie plots and then check how well they correlate with the given metadata.

## Start LCM

![](Example_Data/Screenshots/start_ilcm.png?raw=true)
Start a Shiny-Server instance and choose the iLCM directory.

![](Example_Data/Screenshots/start_ilcm2.png?raw=true)

## Import example data
In order to import the example data to the iLCM, switch to the **Import/Export Tab** in the sidebar. Then select **movies_1** as the data to import and hit **Upload selected data to DB** and **import data to solr** afterwards. When the tasks are fnished you will see a success-message.

![](Example_Data/Screenshots/import_movies.png?raw=true)
Uploading the data to the database and solr might take a few minutes.

## Create a collection
A collection is a subset of the imported data. All analysis in the iLCM are based on a chosen selection. Therefore, we create a collection, containing all imported movie plots. We switch to the **Explorer Tab**. When we hit the **Search** button in the top right without a query, all available documents will be returned. Afterwards we **specify a collection name** and **save** it. 
![](Example_Data/Screenshots/create_collection.png?raw=true)

## Deduplication
In order to make sure, our dataset does not contain any duplicates, we start a deduplication task. Therefore, we switch to the **Collection Worker** and select the **Task Scheduler**. Here we choose the collection we just created and select **Document Deduplication** as analysis. Next, we can click on **Submit Request**. This will start the execution of the deduplication script, whose progress we can follow using the **My Tasks** Area.
![](Example_Data/Screenshots/start_deduplication_task.png?raw=true)

## Check Logs
In the **My Tasks** are we can check the logs of failed, running, and finished tasks. To check the progress of the document deduplication, we hit the box of the **running** tasks. There we see a table, where we select the corresponding task, we are interested in. Then we can see the logs of chosen tasks. After a task is successfully finished, its log file is transferred to the **finished** directory.

![](Example_Data/Screenshots/check_logs1.png?raw=true)

## Check Deduplication Results
When we observed that the deduplication task has finished following the logs, we switch to the **Results** Area. Here every available analysis category, has its own box. Because we started a Deduplication Task, we open the dedicated box. Here we should see the started task. We select this, by clicking somewhere in the row. This will then automatically transfer us to the **Details** Area, where we can check the results in more detail. 
  
![](Example_Data/Screenshots/open_deduplication_results.png?raw=true)


We can then select different strategies to dissolve the found duplicates. In this example we choose to always use the older version of tow duplicate documents. In the graph, all the found duplicates are shown. The red nodes represent the documents that will be deleted by the chosen strategy.

![](Example_Data/Screenshots/deduplication.png?raw=true)

Zoomed in, the titles of the documents are shown. If one double-klicks on a node, more details and a diff view for this document and it's duplicates is available. 

![](Example_Data/Screenshots/deduplication2.png?raw=true)


Once we are satisfied, with the current configuration, we can click on **Save Collection** to create a new collection, in which the red nodes will be removed and therefore no duplicates are present. If we want to export, this data from the LCM, we can also just download **duplicate free data** as a CSV and use the data elsewhere.



## Start Topic Model

In order to create semantic topics from the movie plots automatically, we need to start a topic model task. Here we switch back to the **Task Scheduler** again and select the deduplicated collection and Topic Modelling as analysis. Next, we can choose the parameters for the preprocessing. Here we use a custom blacklist, that contains a list of names, that will be removed from the analysis. In addition to that we will exclude all words with the named entity tag **PERSON**. Removing the names from the movie plots will support the model in finding semantic clusters of words as topics . In addition to that, we choose a pruning setting where, we exclude all words, which don't occur at least five times over the whole dataset. 

![](Example_Data/Screenshots/start_topic_model.png?raw=true)

Once we are satisfied with the configuration, we can click **submit request** and switch to the **My Tasks** section to check the logs and see when the task is finished.

![](Example_Data/Screenshots/check_logs2.png?raw=true)


## Inspect Topic Model Results

When the task is finished we need to switch back to the **Results** Area. Here we open the **Topic Model** Box and select the finished task. Then we are transferred to the details tab and the results are loaded. Using [LDA Vis](https://github.com/cpsievert/LDAvis) we can then start to inspect the resulting models. For example, we can identify a topic consisting of fantasy-related words 

![](Example_Data/Screenshots/topic_model1.png?raw=true)

and one dealing with science fiction.

![](Example_Data/Screenshots/topic_model2.png?raw=true)


We can then validate the found topics using the original documents. Therefore, we switch to the validation tab and select a Document, we want to use. Here we choose *Lord of the Rings - Return of the King*. We can then see it's topic distribution as a pie chart. We can then select a topic. Here we chose Topic 6, which is the one, the documents has the highest likelihood for. In the document then those words are highlighted, that are particularly likely only in this topic. In this example we can identify words like *Hobbit*, *Orcs*, *Sword* and some *Lord of the Rings related characters and places*. 

![](Example_Data/Screenshots/topic_model4.png?raw=true)


## Check Correlation of Sections with found Topics

Afterwards we can also check, weather the found topics, correlate with given metadata-section information of the documents. 
We here select the *Science Fiction Topic*. The associated documents mostly show the metadata science-fiction  and superhero, which agrees with our interpretation of the topic.

![](Example_Data/Screenshots/topic_meta.png?raw=true)





