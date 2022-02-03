# musical-feelings
Data analysis dashboard using SpotifyAPI and R

Link to dashboard: https://jctubio.github.io/musical-feelings/

### Collaborators
- Aaron Kaltenmaier (Universiteit van Amsterdam)
- Julia Zeuzem (Universiteit van Amsterdam)
- Néstor Narbona Chulvi (Universiteit van Amsterdam)
- Lieve Jilesen (Vrije Universiteit Amsterdam)
- Juan Cruz Tubio (Vrije Universiteit Amsterdam)

## Motivation & Research question
The demand for music has grown to become an important aspect of many peoples’ everyday life (Fuentes et al., 2019). Especially, the mode of music listening has shifted from only actively listening to music from time to time, to the soundtracking of daily activities. People accompany various activities with music, and it becomes an affective-practical resource. Songs have shown to change and strengthen peoples’ emotions, help patients’ with their anxiety and improve workers’ concentration (Sloboda et al., 2001; Mok & Wong, 2003; Lesiuk, 2005).
A high demand for music automatically leads to a high demand for research in music listening behaviour. Several studies have focused on Music Emotion Recognition (MER) (Aljanaki et al. 2014). It focuses mostly on two dimensions: “valence (positive vs. negative) and arousal (quiet vs. energetic). However, the perfect MER model has not yet been found. 

Subjective and objective views on music sometimes differ (Song et al., 2016). The way people perceive the valence of music and the song’s music tags often differ due to individual factors like mood, cultural background and experience. This study will try to understand the measurement of valence and whether subjective and objective valence differs as much in our sample. Additionally, studies have shown that musical sophistication has an effect on the relationship between objective and subjective musical perception (Castro & Lima, 2014). We will examine whether the level of expertise in music will impact musical perception in the context of valence, leading to the following research question:

### Research Question
**To what extent does objective valence judgement predict subjective happiness ratings and to what extent is this relationship moderated by music sophistication?**

## Hypotheses / Assumption

Spotify offers 12 APIs that are known as successful measures of musical characteristics in songs (Panda et al.,2021). Valence is one of them, and it describes the level of positivity a song has. As Spotify is a world-wide leading music streaming service with a lot of access to consumer behaviour, its measures of valence are argued to be objective measures capable of predicting consumers’ subjective ratings of a song's positivity and happiness. 
* The first assumption in this study is:
  * Spotify’s valence measurement predicts subjective happiness ratings.
As mentioned before, research has shown that musically sophisticated people rate musical characteristics more similar to objective, music-theory based measures, than people who are less involved in making or listening to music (Castro & Lima, 2014). 
* Applying these findings to valence ratings, the following hypothesis is assumed: 
  * The association between valence and happiness ratings is stronger with higher levels of musical sophistication.
The better understanding of music of more sophisticated people indicates that ‘music experts’ are not only better at rating sound characteristics, but that their answers were more align as they based their decision on music-theory (Castro & Lima, 2014). 
* Applying these findings to valence ratings, the following hypothesis is assumed:
  * Higher musical sophistication is associated with a lower variance in happiness ratings compared to low musical sophistication.

## Method
In accordance with the hypotheses, the measured variables were participant’s happiness ratings per song (DV), Spotify’s valence ratings per song (IV) and the participants’ respective levels of musical sophistication (IV / Moderator).
A convenience sample was gathered by distributing the questionnaire to friends, family, colleagues and other students.
The valence ratings were sourced from the web-version of the Spotify API. The remaining, participant-specific data was gathered through Qualtrics using a mixed design. After signing the informed consent, participants were first asked to judge the happiness of 15 songs which were selected from the Dutch Charts playlist on Spotify. 
**The songs were selected in a manner so that the spectrum from very low to very high valence (Spotify API) was completely covered.** 
Following this, the participants were asked to fill out the Goldsmith Musical Sophistication Index (Gold-MSI) questionnaire, specifically the 18 items measuring the general musical sophistication subscale. For each item, participants are asked to indicate their agreement to the given statement on a scale from “Completely Disagree” to “Completely Agree”. Example items include “I can sing and play music from my memory” and “I would not consider myself a musician” (reverse-coded). 


## Playlist
The following songs were obtained from Spotify's Netherlands top songs around mid december 2021.
![image](https://user-images.githubusercontent.com/19409055/151416994-3fd3c776-4ff6-4967-b12c-e9da61c699a2.png)




