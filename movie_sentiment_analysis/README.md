# Sentiment Analysis on Movie Reviews 
#### Natural Language Processing
Sentiment analysis in text mining is the process of categorizing opinions expressed in a piece of text. The objective of this project is to do sentiment analysis on movie reviews to determine whether the reviewer’s sentiment towards the movie is positive or negative.

The [IMBD movie reviews dataset](http://ai.stanford.edu/~amaas/data/sentiment/) is stored in the **data** folder and it contains some directories (called `pos` and `neg`) where reviews are stored in text files named following the convention [[id]_[rating].txt] where [id] is a unique id and [rating] is the star rating for that review on a 1-10 scale. For example, the file [train/pos/200_8.txt] is the text for a positive-labeled train set example with unique id 200 and star rating 8/10 from IMDb.

To determine the reviewer's sentiment, we've implemented several representation algorithms, including **Bag of Words**, **TF-IDF vectors** and **Word2Vec**. All these algorithms allow us to transform words in each review into a vector that we can use to feed our Machine Learning Classifiers (in this case Random Forests and Neural Networks).

The project contains 2 Jupyter Notebooks. In **IMBD Movie Reviews Sentiment Analysis** you will find the Bag of Words and TF-IDF techniques applied to the dataset while in **Word2vec Sentiment Analysis** you will find the Word2vec technique applied.
