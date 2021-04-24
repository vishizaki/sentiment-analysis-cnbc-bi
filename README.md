Sentiment Analysis for CNBC and Business Insider articles
R code for sentiment analysis on CNBC and Business Insider articles

I believe that with a good financial planning and a great investment strategy, people can succeed on achieving their financial independence. Nowadays we have a lot of options of products to invest, ranging from conservative investment on savings to complex products such as options and to newly developed sources of investments such as crypto currency. With that said, not only we need to be aware of the different financial instruments but also we need to know about economy and trends in order to do the best investment in the correct time frame, as an example, during periods of bearish markets, people tend to go to more conservative investments such as fixed income and if you are not aware, you can lose a lot of money on the stock market.

Knowing the complexity of the financial markets, we need to find a good source of information to keep us up to date in terms of business, so the goal of this report is to compare two important sources of information and conclude which one will be the best fit for us as an investor. 

To start, we generated a web scrapping script using Ruby to get information from articles from CNBC and Business Insider, which are 2 major sources of market information, after that we saved those files as .csv to be able to import on R.

On the left side we can see the sentiment analysis for Business Insider and on the right side, for CNBC.

Business Insider             |  CNBC
:-------------------------:|:-------------------------:
![](/report_images/Rplotfreq_bi.png)  |  ![](/report_images/freq_cnbc.png)

By analyzing the graphs we can get some good information on what to expect from each source. We can see that Business Insider shows a higher proportion of articles with negative words when compared to CNBC and as we are experienced investors, we consider that negative information will be good a measure for market behavior and we could possibly foresee bad trends on the stock markets. We did not consider positive words as relevant because it’s highly available on both sources. Anticipation and fear being relevant of both sources is a good indicator for our current situation because we are facing record highs on the stock market and that could also be an alert for possible recession. 
We noticed that CNBC appears to have a lighter content compared to Business Insider, once we see fewer negative words and joy is much more relevant.
We can see below our TF-IDF analysis chart:

TF-IDF Chart             
:-------------------------:
![](/report_images/tf_idf.png)

Considering our previous analysis, we have indications that CNBC has a lighter content and so far Business Insider seems to be more relevant for our purposes.

By analyzing relevant tf-idf words on CNBC, we noticed that we could find that leisure related information are more important and we can see words like travel and restaurant. One interesting finding is related to our current situation with COVID, as CNBC tends to address more the scientific and health side of the situation with words like CDC, FDA and study and on the other side Business Insider is focusing on the same issue but more focused on the economy, as we can see important words like income, checks, relief, credit, school and wage. I tend to follow the financial market but specially tech companies and in this topic, CNBC does not seem to show relevant information as we can see a lot of government related topics and compared to Business Insider, that has the words app and apps as relevant.

Based on the text analysis done on both important and relevant sources for the financial markets, we have concluded that for our purposes and considering that we are avid investors in the financial markets and specially in tech companies, using Business Insider as our main source of information seems to be a better fit for our needs and summarizing our findings, Business Insider has a higher rate of negative words which can helps us be better prepared for getting out of important positions in stocks and also get a better feeling of how close a bearish market is coming. Going into the details of important words, we noticed that Business Insider is also focusing more on the economy compared to CNBC which would go to a more technical details.
