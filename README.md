**SingingVoice-MFA-Training**

Hello, everyone! I'm a graduate student in Shanghai who major in phonetics. I'm highly grateful to my college and my institution (Institute of Linguistics, IOL) for providing me with interdisciplinary knowledge for language studies. My institution offers me a chance to learn about traditional linguistic knowledge and frontiers of speech science. Special thanks to my supervisor Mr. Zhu, who constantly encourages me to pursuit my dream.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Task 1 : Split TextGrid to Sentence level](#task-1--split-textgrid-to-sentence-level)
- [Task 2 : Convert Split TextGrids to Corresponding txt files](#task-2--convert-split-textgrids-to-corresponding-txt-files)
- [Task 3 : MFA acoustic model training](#task-3--mfa-acoustic-model-training)
- [Task 4 : Evaluation of MFA acoustic model and future improvements](#task-4--evaluation-of-mfa-acoustic-model-and-future-improvements)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

2022.09.02

##### Task 1 : Split TextGrid to Sentence level

In the [Opencpop dataset](https://wenet.org.cn/opencpop/), the textgirds is given in a level of the whole song. It also offers split wav files in the sentence level, so we need to split the textgrids to the sentence level, which makes them suitable for aligning with split wav files.

***split_textgrid_addictive_order.praat*** is based on praat scripting, where I combined the praat scripts offer by [Articulatum](https://www.zhihu.com/people/articulatum) and [ShaoPengfei](https://github.com/feelins/Praat_Scripts). The function of this file (ending with .praat) is to split original textgrids offered by Opencpop to sentence level, with the same name of their corresponding wav slices.

You need to download [Praat](https://www.fon.hum.uva.nl/praat/) to make ***split_textgrid_addictive_order.praat*** available to be opened. Double click ***split_textgrid_addictive_order.praat***  and Praat will automatically open itself. 

The only two things you need to do include: 1. Put all original textgrids into the folder ***original-textgrid*** (you can change the folder name as you wish) 2. Click the button ***"Run"*** in the pop-up window of Praat, and change the path of ***Directory_name*** (the folder contains original textgrids) and ***output_Directory_name*** (the folder you wish to store the split textgrid). 

![image-20220903145610082](https://i0.hdslb.com/bfs/album/14e752411dd7b3af3feda1edb6cce2f0b1a5f646.png)

2022.09.03

##### Task 2 : Convert Split TextGrids to Corresponding txt files

When you finish task 1, you would get 3756 split textgrids. Every split textgrid would be perfectly aligned with its corresponding wav files (with the same name). You can check it through Praat by randomly opening one split textgrid and one wav file with its same name. 

Task 2 helps you get all files required for MFA acoustic model training (split wav files, their transcriptions in the word level saved in txt format, a dictionary containing mapping relations between words and phonemes). The dictionary has been offered here, which was made of a given [pinyin to phoneme mapping table](https://wenet.org.cn/opencpop/resources/annotationformat/) offered by Opencpop and 19 Out-of-vocabulary (OOV) word types that I appended on my own.

A jupyter notebook named ***split_textgrid_to_txt_extractor.ipynb*** is offered here for task 2. The function of this notebook include: 1. Extract the third tier of textgrid (tier named “音节”) and append the symbols in to list 2. For special symbols [ SP, AP, and _ ] ,  SP and AP would be remained,  _ would be replaced by the final rhyming part of the former Chinese syllable 3. Create 3756 txt files with the same name of 3756 split textgrids. 

Taking the textgrid shown in the picture as an example, after we finish task 2, its corresponding txt file would be automatically built in the folder ***split-textgrid-to-txt***, with the content "piao fu zai ai ai AP SP yi i pian ian ian wu nai SP AP ". By the way, thanks to the help of [yqzhishen](https://github.com/yqzhishen). He made me finally realize that SP refers to silence. AP refers to aspiration, and _ refers to the lengthening of final rhyming part.

![image-20220903154154186](https://i0.hdslb.com/bfs/album/7923271bf88ba266a33e1b1f8e5a1c259df6e3b7.png)

2022.09.04

##### Task 3 : MFA acoustic model training

For the installation of MFA, I highly recommend you to install MFA in the linux system. Windows can  activate a sub-system of WSL (Windows Subsystem for Linux). My environment is Ubantu 18.04 and WSL 1.0. Besides, I highly recommend you to install MFA by following the procedures offered by Official Guidelines : 

1. MFA can be installed with Anaconda or Miniconda ([instruction here](https://montreal-forced-aligner.readthedocs.io/en/latest/installation.html)).

2. After the installation of Conda, run command 
    `conda create -n aligner -c conda-forge montreal-forced-aligner`

3. Activate new environment with the command
    `conda activate aligner`

4. Check whether MFA has been successfully installed

   `mfa version` or `mfa model download acoustic english_us_arpa`

To help you be familiar with the process of installation and model training of MFA, I create a jupyter notebook ***MFA_for_Colab.ipynb***. You can open it with google colab and run MFA online by click the button one by one. 

To train an acoustic model of MFA, you need to prepare three things (the split wav files, their corresponding transcriptions in the word level saved in txt format, a dictionary that stores the mapping relations between words and phonemes). Here, the split wav files and their corresponding transcriptions are stored in the folder ***my_corpus***, and the dictionary storing mapping relations is ***my_dictionary.txt***.

Then, you can use the command  `mfa train --clean /content/SingingVoice-MFA-Training/my_corpus /content/SingingVoice-MFA-Training/my_dictionary.txt /content/SingingVoice-MFA-Training/acoustic-model-training/opencpop_acoustic_model.zip /content/SingingVoice-MFA-Training/acoustic-model-training` to train your acoustic model for singing voice auto-aligning. 

You should pay attention to these four paths here. The first path is where you store the wav files and their transcriptions. The second path is the path of your dictionary. The third path is where you'd like to store the newly trained acoustic model (you can change its name with xxxxx.zip as you wish). The last path is where you'd like to store the newly produced aligned textgrids. `mfa train --clean <corpus path> <dictionary path> <acoustic model path> <aligned textgrids path>` 

##### Task 4 : Evaluation of MFA acoustic model and future improvements



![image-20220904114557596](https://i0.hdslb.com/bfs/album/782e040ed2196cd38bd13abfb0b975b21f2eadd5.png)

