# Spam Classifier
The objective of this project is to build a simple email spam classifier using Machine Learning Techniques. The data used in this notebook was provided by [Euron-spam corpus](https://www2.aueb.gr/users/ion/data/enron-spam/) and it consists of around 33716 preprocessed emails. I've implemented BagOfWords and Term Frequency-Inverse Document Frequency vectors to represent the data and feed the ML models.

The main ideas of the projects were trying to implement different **custom made Transformers** into **Pipelines** to then apply different preprocessing steps to the dataset. I've done hyperparameter finetuning during the preprocessing and modeling phases using **GridSearchCV()**.

The project code is available in a Jupyter Notebook and it consists of the following steps:
1. Fetch and load the dataset.
2. Explore the dataset (number of instances, number of instances in each class, email's structures, etc.).
3. Train-test data split.
4. **Word Tokenizer**: Build a transformer who main task is to split each instance of the dataset into a list of words.
5. **Data Cleaner**: Build a transformer that performs several data cleaning techniques such as stop-words removing, stemming and lemmatization. These techniques aim to improve the model's overall performance.
6. **Word Counter**: Build another transformer whose objective is to create a Counter() object for each instance in the **cleaned** dataset with the number of times that each word appeared.
7. **Bag of Words Vectorizer**: It involves converting a piece of text, such as an email or message, into a numerical feature vector based on the frequency of occurrence of words in that text. The idea behind BoW is that the presence and frequency of specific words can help determine whether a text is spam or not.
8. **TF-IDF Vectorizer**: It uses mathematical formulas that takes into account not only the frequency of occurrence of words but also their importance in the context of the entire corpus to predict whether or not a text is spam.
9. Build training Pipelines and perform GridSearchCV to determine which hyperparameter performs better in the training set.
10. Make predictions with the best models of the GridSearchCV in the test set.
11. Determine performance metrics in the test set.
