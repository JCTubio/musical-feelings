library(tidyverse)
library(ggplot2)
music_ds <- readxl::read_excel('Music_ds.xlsx')
###Deleting uncomplete/suspiciously long participants###

  #Select only participants who finished the questionnaire with no problems
cln_music <- music_ds%>%
  subset(Status==0 & Finished == 1)

  #Select only participants that took more than 4 minutes to do the questionnaire
cln_music <- cln_music%>%
  subset(`Duration (in seconds)`>240)

length(cln_music$ResponseId) #number of participants 

  #Dataset with important variables
stats_ds <- cln_music%>%
  select(-c(Status:RecordedDate),-Q21)

  #Chnage var names to delete spaces
colnames(stats_ds)[2:16] <- tolower(gsub('g ','g',colnames(stats_ds)[2:16]))

###Change the order of Song_n scores so higher score = happier song###

my_fun <- function(x){8-x}
new_cols<- t(apply(stats_ds[,2:16],1,my_fun))

stats_ds <- cbind(stats_ds,new_cols)

stats_ds <- stats_ds%>%
  select(-(2:16))

###1. Predicting valence with happiness ###

  #get songs valence
vlncs <- data.frame(song = colnames(stats_ds)[20:34], valence = c(0.934,0.892,0.88,0.736,0.598,0.537,0.418,0.262,0.637,0.109,0.130,0.403,0.473,0.531,0.354))

  #put data in the right format

reg_ds <- stats_ds%>%
  pivot_longer(song1:song15)%>%
  select(song = name, hppy = value,ResponseId)%>%
  inner_join(vlncs)

  #standardizing scores per participant (i.e. explaining out within participant variances)

part <- unique(reg_ds$ResponseId)
stand_ds <- data.frame(song = NA, hppy = NA, ResponseId = NA, valence = NA, z_hppy = NA)

for(i in 1:length(part)){
  this_part <- reg_ds%>%
    subset(ResponseId == part[i])%>%
    mutate(z_hppy = (hppy-mean(hppy))/sd(hppy))
  stand_ds <- stand_ds%>%
    add_row(this_part)
  ifelse(i == length(part),stand_ds <- stand_ds[-1,],NA)
}


  #check assumptions
    #linearity
ggplot(stand_ds, aes(x = hppy, y = valence))+
  geom_point(position = 'jitter')

library(car)
qqPlot(fit)

hist(resid(fit),breaks = 20)
    #homoscedasticity
plot(fitted(fit),resid(fit))
lines(c(0.34,0.7),c(0,0), lty = 2,lwd = 2)
  
    #sensitivity
plot(hatvalues(fit))
  
  #fit the simple linear regression
fit <- lm(valence ~ z_hppy,stand_ds)

summary(fit)

  #plots
    #scatterplot (very bad)
p <- ggplot(reg_ds, aes(x = hppy, y = valence))+
  geom_point(position = 'jitter')
p+geom_smooth(method = 'lm')

    #boxplot (beautiful)
reg_ds%>% 
  ggplot(aes(factor(hppy), valence))+ 
  geom_boxplot(fill = '#1DB954')+
  xlab('Happiness rating')+
  ylab('Song valence')+
  labs(title = 'Song valence boxplots', subtitle = 'Distribution of valences for songs rated at different happiness level')


  #Barplots showing a the slight trend (unnecesary i think)
sample <- sort(c(0.934,0.892,0.880,0.262,0.109,0.130))

for_plot <- reg_ds%>%
  subset(valence %in% sample)%>%
  arrange(valence)

par(mfrow = c(2,3), font = 2, cex.main = 1.5)
for(i in 1:6){
  this_ds <- for_plot%>%
    subset(valence == sample[i])
  
  name <- gsub('s','S',this_ds$song[1])
  vlc <- this_ds$valence[1]
  avg <- mean(this_ds$hppy)
  
  this_ds <- this_ds%>%
    count(hppy)
  if(i == 2){
    this_ds <- this_ds%>%
    add_row(hppy = 7, n =0)
  } else if(i == 4){
    this_ds <- this_ds%>%
      add_row(hppy = 2, n = 0,.before = 1)%>%
      add_row(hppy = 1, n =0,.before = 1 )
  }else {
    this_ds <- this_ds%>%
    add_row(hppy = 1,n = 0,.before = 1)
  }
  barplot(this_ds$n, ylim = c(0,30),col = '#1DB954',names.arg = this_ds$hppy, 
          main = paste(c(name,'   Vlc = ',vlc),collapse = ''))
  lines(c(avg,avg),c(0,40),col = '#ff382f', lty = 2,lwd = 2)
  text(avg+0.6,28,col ='#ff382f', round(avg,3),font = 2,cex = 1.5)
  
  }
  


###2. Moderation analysis including music sophistication ###

  #get sophistication scores
sphst <- stats_ds%>%
  select(ResponseId,Q16_1:Q19)%>%
  mutate(Q16_7 = 8 - Q16_7)%>% #correcting the contraindicative items
  mutate(Q16_9 = 8 - Q16_9)%>%
  mutate(Q16_11 = 8 - Q16_11)%>%
  mutate(Q16_13 = 8 - Q16_13)%>%
  mutate(Q16_14 = 8 - Q16_14)
sphst <- sphst%>%
  mutate(sophi = rowSums(sphst[,2:19]))%>%
  select(ResponseId,sophi)
  
  #get dataset 
mod_ds <- stats_ds%>%
  pivot_longer(song1:song15)%>%
  select(ResponseId,song = name, hppy = value)%>%
  inner_join(vlncs)%>%
  inner_join(sphst)%>%
  select(-hppy,-valence)%>%
  inner_join(stand_ds, by = c('song','ResponseId'))



  #Check multicollinearity 
library(car)
vif(fitMod)

  #Perform the analysis

    #Center data
X <- mod_ds$hppy
Z <- mod_ds$sophi
Y <- mod_ds$valence

X <- c(scale(X, center = T, scale = F))
sophistication <- c(scale(Z, center = T, scale = F))

    #Fit model
library(gvlma)
fitMod <- lm(Y ~ X + sophistication + X*sophistication) 
summary(fitMod)

    #Plot
library(rockchalk)
ps  <- plotSlopes(fitMod, plotx="X", modx="sophistication", xlab = "Happy", ylab = "Valence", modxVals = "std.dev")

#for plot boxplot for each group next to each other

low <- sort(sphst$sophi)[1:(length(sphst$sophi)*(1/3))]
mid <- sort(sphst$sophi)[(length(sphst$sophi)*(1/3)+1):(length(sphst$sophi)*(2/3))]
high <- sort(sphst$sophi)[(length(sphst$sophi)*(2/3)+1):(length(sphst$sophi))]

#make data set 
plot_ds <- stats_ds%>%
  pivot_longer(song1:song15)%>%
  select(ResponseId,song = name, hppy = value)%>%
  inner_join(vlncs)%>%
  inner_join(sphst)%>%
  mutate(grp = ifelse(sophi %in% low, 1,2))%>%
  mutate(grp = ifelse(sophi %in% high,3,grp))%>%
  mutate(grp = as.factor(grp))

plots <- list()

cols <- c('#c5f6d6','#83eca7','#1db954')
titles <- c('Low','Mid','High')

for(i in 1:3){
  this_plot <- plot_ds%>%
    subset(grp == i)
  plots[[i]] <- ggplot(this_plot,aes(x=factor(hppy),y=valence))+
    geom_boxplot(fill = cols[i])+
    labs(title = paste(c(titles[i],' sophistication'),collapse = ''))+
    xlab(label = 'Happiness score')+
    ylab(label = ifelse(i == 1,'Valence',''))+
    theme_minimal()+
    theme(plot.title = element_text(face="bold"))
}

gridExtra::grid.arrange(plots[[1]],plots[[2]],plots[[3]],ncol= 3)




###3. Comparing variances among different sophistication groups###

  #make the three different sophistication groups

low <- sort(sphst$sophi)[1:(length(sphst$sophi)*(1/3))]
mid <- sort(sphst$sophi)[(length(sphst$sophi)*(1/3)+1):(length(sphst$sophi)*(2/3))]
high <- sort(sphst$sophi)[(length(sphst$sophi)*(2/3)+1):(length(sphst$sophi))]

  #make data set 

var_ds <- stats_ds%>%
  pivot_longer(song1:song15)%>%
  select(ResponseId,song = name, hppy = value)%>%
  inner_join(vlncs)%>%
  inner_join(sphst)%>%
  mutate(grp = ifelse(sophi %in% low, 1,2))%>%
  mutate(grp = ifelse(sophi %in% high,3,grp))%>%
  mutate(grp = as.factor(grp))

  #calculate levene's test and make plots

songs <- unique(var_ds$song)
plot <- list()

for(i in 1:15){
  song <- var_ds%>%
    subset(song == songs[i])
  lev_p <- p.adjust(car::leveneTest(song$hppy,song$grp)$`Pr(>F)`[1],'bonferroni',15) #we correct for multiple testing
  plot[[i]] <- ggplot(song,aes(grp,hppy,fill = grp))+
    geom_boxplot()+  
    ggtitle(paste(c('Song ',i,"     Levene's p = ",round(lev_p,4)),collapse = ''))+
    scale_x_discrete(labels = c('low','mid','high'))+
    xlab(ifelse(i %in% 11:15,'sophistication',''))+
    ylab(ifelse(i %in% c(1,6,11),'happy',''))+
    theme(plot.title = element_text(face="bold"))+
    scale_fill_manual(values = c('1' = "#c5f6d6",
                                 '2' = "#83eca7",
                                 '3' = "#1db954"))+
    theme_minimal()+
    theme(legend.position = 'none')+
    scale_y_continuous(breaks = seq(1,7,by = 1))+
    ylim(1,7)
  }


gridExtra::grid.arrange(plot[[1]],plot[[2]],plot[[3]],plot[[4]],plot[[5]],plot[[6]],plot[[7]],
                        plot[[8]],plot[[9]],plot[[10]],plot[[11]],plot[[12]],plot[[13]],
                        plot[[14]],plot[[15]],nrow = 5)


