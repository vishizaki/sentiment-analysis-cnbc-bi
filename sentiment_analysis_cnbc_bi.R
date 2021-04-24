# Libraries
library(readr)
library(tidyverse)
library(tidytext)
library(stringr)
library(ggplot2)

# Creating a dataframe with scrapped text from Business Insider
business_insider_df <- data.frame(read_delim("/Users/vinicius/code/vishizaki/sentiment-analysis-cnbc-bi/data.csv",
                     "\t", escape_double = FALSE, col_names = FALSE,
                     trim_ws = TRUE))
# Renaming column name to text
names(business_insider_df)[1] <- "text"

# Creating a dataframe with scrapped text from CNBC Business
cnbc_df <- data.frame(read_delim("/Users/vinicius/code/vishizaki/sentiment-analysis-cnbc-bi/data_cnbc.csv",
                                             "\t", escape_double = FALSE, col_names = FALSE,
                                             trim_ws = TRUE))
# Renaming column name to text
names(cnbc_df)[1] <- "text"

# Function to tokenize and remove stop words
data(stop_words)
tokenizing_remove_stop_words <- function(df){
    df %>%
    unnest_tokens(word, text) %>%
    anti_join(stop_words) %>% #here's where we remove tokens
    select_if(Negate(is.integer)) %>% 
    count(word, sort=TRUE) %>%
    mutate(word=reorder(word, n))
}

# Running function to get a clean list of tokens without stop words
token_list_bi <- tokenizing_remove_stop_words(business_insider_df)
token_list_cnbc <- tokenizing_remove_stop_words(cnbc_df)

# Creating column with source name
token_list_bi$source <- "Business Insider"
token_list_cnbc$source <- "CNBC"

# Combining data
token_list_consolidated <- rbind(token_list_bi, token_list_cnbc)

# Getting frequency plot function
plot_freq_hist <- function(token_list){
  token_list %>% 
    head(30) %>% 
    ggplot(aes(word, n))+
    geom_col()+
    xlab(NULL)+
    coord_flip()
}

# Generating frequencies:
freq_hist_bi <- plot_freq_hist(token_list_bi)
freq_hist_cnbc <- plot_freq_hist(token_list_cnbc)

# Visualizing frequency tokens
print(freq_hist_bi)
print(freq_hist_cnbc)

# Using sentiment analysis libraries
afinn <- get_sentiments("afinn")
nrc <- get_sentiments("nrc")
bing <- get_sentiments("bing")

# Combining and adding source name
sentiments <- bind_rows(mutate(afinn, lexicon="afinn"),
                        mutate(nrc, lexicon= "nrc"),
                        mutate(bing, lexicon="bing")
)

# Reading unique values
unique(sentiments$sentiment)

# Removing NA from the sentiment list
sentiments_no_na <- sentiments %>% 
                    filter(!sentiment %in% NA)

# Getting sentiment list for Business Insider
sentiment_list_bi <- token_list_bi %>%
  inner_join(sentiments_no_na) %>%
  count(sentiment, sort=T) %>% 
  head(20)

# Getting sentiment list for CNBC  
sentiment_list_cnbc <- token_list_cnbc %>%
  inner_join(sentiments_no_na) %>%
  count(sentiment, sort=T) %>% 
  head(20)

# Summary of sentiment tokens for CNBC
sentiment_list_cnbc %>%
  mutate(sentiment = fct_reorder(sentiment, desc(n))) %>% 
  head(30) %>% 
  ggplot(aes(sentiment, n))+
  geom_col()+
  xlab(NULL)+
  coord_flip()

# Summary of sentiment tokens for Business Insider
sentiment_list_bi %>% 
  mutate(sentiment = fct_reorder(sentiment, desc(n))) %>% 
  head(30) %>% 
  ggplot(aes(sentiment, n))+
  geom_col()+
  xlab(NULL)+
  coord_flip()


# Calculating TF IDF (how relevant a word is to a document in a collection of documents)
# Grouping and summarizing the total number of words per source for TF IDF calculation
total_words <- token_list_consolidated %>%
  group_by(source) %>%
  summarize(total=sum(n))

# Joining total number of words to token list
consolidated_df <- left_join(token_list_consolidated, total_words)

# Visualizing histogram
ggplot(consolidated_df, aes(n/total, fill = source))+
  geom_histogram(show.legend=FALSE)+
  xlim(NA, 0.01) +
  facet_wrap(~source, ncol=2, scales="free_y")

# Calculating the term frequency
freq_by_rank <- consolidated_df %>%
  group_by(source) %>%
  mutate(rank = row_number(),
         `term frequency` = n/sum(n))

# Plotting the term frequency
freq_by_rank %>%
  ggplot(aes(rank, `term frequency`, color=source))+
  #let's add a tangent line , the first derivative, and see what the slop is
  geom_abline(intercept=-0.62, slope= -1.1, color='gray50', linetype=2)+
  geom_line(size= 1.1, alpha = 0.8, show.legend = FALSE)+
  scale_x_log10()+
  scale_y_log10()

# Binding dataframes
consolidated_df <- consolidated_df %>%
  bind_tf_idf(word, source, n)

# Plotting consolidated TF IDF results
consolidated_df %>%
  arrange(desc(tf_idf)) %>%
  mutate(word=factor(word, levels=rev(unique(word)))) %>% #converting tokens to factors
  group_by(source) %>%
  filter(n<5) %>% 
  top_n(15) %>%
  ungroup %>%
  ggplot(aes(word, tf_idf, fill=source))+
  geom_col(show.legend=FALSE)+
  labs(x=NULL, y="tf-idf")+
  facet_wrap(~source, ncol=2, scales="free")+
  coord_flip()

