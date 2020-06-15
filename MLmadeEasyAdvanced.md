# ML made easy - Advanced
## Introduction

<a href="/csp/sys/exp/%25CSP.UI.Portal.SQL.Home.zen?$NAMESPACE=USER" target="_blank">SQL Editor</a>

In this exercise, you will use IntegratedML to create, train, and execute a predictive model on a sample data.

While the use case here is based on oversimplified case of predicting Iris flowers, IntegratedML can be used to solve all kinds of different problems with machine learning.

It is intended for developers who want to implement machine learning in their applications but do not have the expertise on hand to do so.

## Objectives

By the end of this exercise, you will be able to:

* Explain what IntegratedML is
* Create a model definition
* Train a model on a set of training data
* Execute a model on set of testing data
* Find and Observe the training process
* Validate a model and view the results
* Choose a different provider to train and test models
* Setting up different IntegratedML configurations
* How to view and maintain existing models

## View Data

Before you can begin to see the benefits of machine learning in an application, you first need to familiarize yourself with the data your application is receiving. 

In this exercise, you will work on two separate tables:

* **DataMining.IrisDataset** - This dataset contains the information of 150 different Iris flowers, with information of their petal and sepal width and length, and its sub-categorization into exact species (Iris Setosa, Iris Virginica, and Iris versicolor.

* **Titanic.Passenger** - List of passengers of Titanic's only journey along with information about their survival.

Your training (input) data should be a representative sample; it needs to be representative enough to give your machine learning engine sufficient data to identify patterns and relationships. 

[comment]: <> (By keeping your testing data in a different set, you can truly see how your model reacts to brand new data; not the data that its training was based on.)

In a real ML use cases, the training processs takes a considerable amount of time. It can take from 10-15 minutes to even couple of weeks to train, depending on the size of the dataset. For the sake of time, we have chosen small Iris flowers dataset.

In this exercise, the two sets of data are already prepared for use in a machine learning application. To learn about some of the key considerations you should think about when preparing your data for machine learning, you can refer to this [infographic](https://learning.intersystems.com/course/view.php?id=1415&ssoPass=1).

Run the SQL command below to view the Iris dataset table (your training data).

	SELECT * FROM DataMining.IrisDataset

Scroll through the table to see the types of values included in each record. Each column contains the following information:

* sepal length in cm
* sepal width in cm
* petal length in cm
* petal width in cm
* class:
	- Iris Setosa
	- Iris Versicolour
	- Iris Virginica

To make it a bit more clear, let's take a look at the following photos of three different iris flowers.

![Iris Flowers](https://shahinrostami.com/images/ml-with-kaggle/iris_class.png "Iris Flowers with depicted Sepal and Petal width and Length")


an important element of the patient’s record, such as their age, whether they have ever been a smoker, or whether they have certain chronic diseases.
Run the SQL command below to view the Encounters2 table (your testing data). You will notice that its structure is exactly the same as Encounters1, but it is a smaller data set.

	SELECT * FROM Encounters2

In the exercise, IntegratedML will use the information in these data sets to identify patterns and relationships and create a predictive model. This model will be designed to predict whether or not a patient will be readmitted to the hospital; in the data set, the result for each patient is in the WillReAdmit column.

## Create and Train a Predictive Mod

Once you have your training data and know what you are trying to predict, you can create a model definition in IntegratedML. To do this, a single line of SQL is required. Run the module below to create a model named Readmission1.

	CREATE MODEL Readmission1 PREDICTING(WillReAdmit) from Encounters1

In the command above, you created a model definition for Readmission1 and specified that it will be predicting the WillReAdmit column from the Encounters1 data set. Next, you can run the moduled below to train your Readmission1 model with the data set specified in the definition. This command may take 1-2 minutes; remember, IntegratedML is learning patterns and relationships across dozens of columns and 10,000 rows in Encounters1.

	TRAIN MODEL Readmission1

In order to train this model, IntegratedML uses a machine learning provider. There are three primary machine learning providers available for use in IntegratedML:

* AutoML — a machine learning engine developed by InterSystems, housed in InterSystems IRIS
* H2O — an open-source automated machine learning platform
* DataRobot — an advanced enterprise automated machine learning platform

Later in this exercise, you will modify your ML Configuration to use different providers. Note that in order to use DataRobot, you need to be a DataRobot customer.

## Execute the Model

In two simple SQL commands, you have created and trained a model called Readmission1 that will predict the value of WillReAdmit for each patient record in a data set. Now, you can execute this model on the testing data we viewed earlier: the Encounters2 table.
Before running the command to execute the model, take a look at the anatomy of this command in the image below.

Run the command below to return a table containing the original ID, the predicted readmission result, and the actual readmission result of the first 100 records in Encounters2.

	SELECT TOP 100 ID, PREDICT(Readmission1) AS PredictedReadmission, WillReAdmit AS ActualReadmission FROM Encounters2

Browse the results. You can see that the model performs pretty well, but not perfectly. That is to be expected. To explore these results at a deeper level, you could select all rows (instead of just the top 100) and brings those results into other tool for analyzing how the model performed on your training data set. In the next section, you will see more options for assessing the model’s performance.
In addition to the PREDICT function, you can also utilize the PROBABILITY function in your results. Take a look at the new command below, noting the addition of a column for ReadmissionProbability.

[image pointing out the addition of the PROBABILITY function]

Run the command below to return a table containing the original ID, the probability of readmission, the predicted readmission result, and the actual readmission result of the first 100 records in Encounters2.

	SELECT TOP 100 ID, PROBABILITY(Readmission1) AS ReadmissionProbability, PREDICT(Readmission1) AS PredictedReadmission, WillReAdmit AS ActualReadmission FROM Encounters2

Browse the results and look at how the probabilities IntegratedML calculated compare to the predictions it made. Naturally, higher probabilities tend to result in positive readmission predictions. However, this does not necessarily follow a strict rule (like all probabilities above 0.50 equating to a positive prediction).
When the results you are predicting are not binary choices, you can add a clause to the PROBABILITY function to specify for which outcome you are calculating the probability. See the example below, where IntegratedML would calculate the probability of the result being orange in a ColorPredictor model.

	[image showing PROBABILITY AS Orange or something, model being ColorPredictor]

Utilizing both the PREDICT and PROBABILITY functions, you can assess how to best use the insights IntegratedML creates for your own application. In the next step, you will see how to validate a model in IntegratedML and see how accurate it is.

You can see that there are four metrics available that provide information about your model:

* **Precision** is a measure that reflects the number of actual positive results out of all predicted positive results; in this case, the percentage of predicted readmissions that were actual readmissions.
* **Recall** is a measure that reflects the number of predicted positives out of all actual positives; in this case, the percentage of actual readmissions that were predicted as such.
* **F-Measure** is a measure that reflects the concerns of both Precision and Recall in one composite score.
* **Accuracy** is a measure that reflects the overall percentage of predictions that were correct.

Using this information, you can understand how well your model performs. Ultimately, to really hone and refine a predictive model, a data scientist is eventually needed. However, knowing this information can help you, even without that expertise.
For instance, when choosing a model for patient readmissions, you may want to err on the side of being cautious (e.g., a preference toward predicting readmission when in doubt, letting fewer true readmissions go undetected). In cases like these, where the cost of a false negative can be high, you may opt for a model with a high Recall score.

## Train Models Using Different Configurations

Throughout the first four steps of this exercise, you have viewed your data, created a model, trained it, and validated it. Those steps have been completed using the default ML configuration for this lab instance.
An ML configuration is a collection of settings that IntegratedML uses to train a model. Primarily, a configuration specifies a machine learning provider that will perform training. In this exercise, the configuration has been the %H2O configuration, which sets H2O as the machine learning provider.
By default, however, IntegratedML will use the %AutoML configuration. This configuration sets the InterSystems AutoML engine to be the machine learning provider. There are other built-in configurations as well, including %DataRobot and %PMML. You can learn more about configurations in the IntegratedML documentation.
You can see a short example of how to easily change providers and retrain an existing model. Run the command below to set the new default configuration to be %AutoML.

	SET ML CONFIGURATION %AutoML

Setting this configuration will set the machine learning provider to be AutoML. Run the command below to re-train your Readmission1 model with the current configuration, naming the new version Readmission2. Like last time, you will use the Encounters2 data set for this training.

	TRAIN MODEL Readmission1 AS Readmission2 FROM Encounters2

Again, this training step will take 1-2 minutes to complete. In much the same way, you can use this syntax to create different models for various subsets of data. For example, if you had a subset of data for ex-smokers, you may want to create a version of your model trained on that data set. It might look something like this:

[image, using command TRAIN MODEL Readmission1 AS SmokerModel FROM SmokerData]

Additionally, you can train a model with a different provider without setting a new ML configuration. This is achieved with a USING clause and a JSON entry. This is shown in the example below.

[image, using command TRAIN MODEL Readmission1 AS AnotherNewModel USING {‘provider’:‘DataRobot’}. }

Feel free to edit the SQL module below to experiment with the various commands you have learned for creating, training, and validating models as well as executing the PREDICT and PROBABILITY functions.

	SELECT * FROM Encounters2

## Summary and Additional Resources

You have now completed Getting Started with IntegratedML. In this exercise, you:
* Created a model definition
* Trained a model on a set of training data
* Executed a model on set of testing data
* Validated a model and view the results
* Set a different ML configuration to train new models

To learn more about IntegratedML, visit the following learning resources:

* [Learn IntegratedML in InterSystems IRIS® - resource guide](https://learning.intersystems.com/course/view.php?id=1346&ssoPass=1)
* [Using IntegratedML - Documentation](https://docs.intersystems.com/iris20202/csp/docbook/Doc.View.cls?KEY=GIML)
