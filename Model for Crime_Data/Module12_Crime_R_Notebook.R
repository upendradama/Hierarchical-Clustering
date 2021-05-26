---
output:
  html_notebook: default
  html_document: default
---
# Hierarchical clustering

### Problem Statement:- 

  - Perform Clustering for the crime data and identify the number of clusters formed and draw inferences.
  
### Data Understanding and Preparation

```{r}
#Reading the dataset
crime <- read.csv("~/desktop/Digi 360/Module 12/crime_data.csv")
```

```{r}
head(crime)
```

```{r}
any(is.na(crime))
```


```{r}
#Removing First column since it is categorical
crime_num <- crime[, -c(1)]
head(crime_num)
```


```{r}
summary(crime_num)
```

### Scaling

Before applying Hierarchical Clustering, we have to normalize the data so that the scale of each variable is the same. Why is this important? Well, if the scale of the variables is not the same, the model might become biased towards the variables with a higher magnitude.

```{r}
crime_scaled <- as.data.frame(scale(crime_num))
summary(crime_scaled)
```

Since all the values here are continuous numerical values, you will use the euclidean distance method.

### Building the Model

```{r}
dist_mat <- dist(crime_scaled, method = 'euclidean')
hclust_ward <- hclust(dist_mat, method = 'ward.D2')
```

```{r}
#Plotting the dendrogram
plot(hclust_ward)
```

The x-axis contains the samples and y-axis represents the distance between these samples. The vertical line with maximum distance is the blue line and hence we can decide a threshold of 6 and cut the dendrogram:We will get 4 clusters after cutting the dendrogram at hight 6.

### Cutting the Dendrogram

```{r}
cut_ward <- cutree(hclust_ward, k = 4)
```

```{r}
plot(hclust_ward)
rect.hclust(hclust_ward , k = 4, border = 2:6)
abline(h = 6, col = 'red')
```

Let's visualize the tree with different colored branches using package `dendextend`

```{r}
suppressPackageStartupMessages(library(dendextend))
ward_dend_obj <- as.dendrogram(hclust_ward)
ward_col_dend <- color_branches(ward_dend_obj, h = 6)
plot(ward_col_dend)
```

```{r}
#Appending the clusters to original dataframe.
suppressPackageStartupMessages(library(dplyr))
crime_cl <- mutate(crime, cluster = cut_ward)
```

```{r}
head(crime_cl)
```

```{r}
#Rename column X as "State"
colnames(crime_cl) <- c("State", "Murder","Assault", "Urbanpop", "Rape", "Cluster")
head(crime_cl)
```


### Visualizing few attributes

```{r}
suppressPackageStartupMessages(library(ggplot2))
ggplot(crime_cl, aes(x=Assault, y = Urbanpop, color = factor(Cluster))) + geom_point()
```

```{r}
suppressPackageStartupMessages(library(ggplot2))
ggplot(crime_cl, aes(x=Rape, y = Urbanpop, color = factor(Cluster))) + geom_point()
```

```{r}
suppressPackageStartupMessages(library(ggplot2))
ggplot(crime_cl, aes(x=Murder, y = Urbanpop, color = factor(Cluster))) + geom_point()
```


```{r}
#Writing the final file with assigned cluster IDs.
write.csv(crime_cl, file="~/desktop/Digi 360/Module 12/crime_final_R.csv")
```

### Conclusion

  - Chosen the threshold as 6 to cut the dendrogram considering above this threshold is maximum distance.
  - The cut-off line is intersecting at four points in dendrogram, so 4 clusters have been chosen.
