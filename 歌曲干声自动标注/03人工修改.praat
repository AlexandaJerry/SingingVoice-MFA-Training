#last modify: 2016/9/23 by Xiong Ziyu
#作为我的偶像之一的熊子瑜老师的脚本在六年后依然稳定运行
#这份脚本根据熊子瑜老师《语音库建设与分析教程》附录脚本修改
#移除了对pitchtier的检查 更改了音频文件和标注文件的路径
#考虑到MFA自动对齐过程的稳定性 移除了部分判断语句

#功能：顺序打开声音和TextGrid数据文件，等待用户手工修改之后点击“前进、后退、结束”等按钮；
#如果点击前进则脚本程序会自动保存数据后进入到下一条，点击后退则返回到上条标注数据
#操作：用户在运行过程中弹出的对话框上点击“前进、后退、结束”等按钮，以控制流程
#注意：脚本程序会在声音文件夹中保存done.log文件，记录操作的文件序号，如果删除，则重头开始计数

form 顺序检校TextGrid和PitchTier数据对象
	sentence sound_file_path 音频
	sentence texgrid_file_path MFA五层标注
	positive Min_(f0) 100
	positive Max_(f0) 600
endform

#清空主窗口对象列表中的数据对象
Create TextGrid: 0, 1, "Mary John bell", "bell"
select all
Remove

#将Praat读取和存储文本文件的编码格式设定为UTF8，避免汉字乱码
Text reading preferences: "UTF-8"
Text writing preferences: "UTF-8"

Create Strings as file list: "fileList", texgrid_file_path$ + "/*.TextGrid"
done$ = "done.log"
doneNum = 1
if fileReadable(done$)
	doneNum =readFile("'done$'")
endif

fNums = Get number of strings
for f from doneNum to fNums
	selectObject: "Strings fileList"
	fName$ = Get string: 'f'
	Read from file: texgrid_file_path$ + "/" + fName$
	objectname$=selected$("TextGrid", 1)
	Read from file: sound_file_path$+ "/" + objectname$ + ".wav"
	selectObject: "TextGrid " + objectname$
	plusObject: "Sound " + objectname$
	View & Edit
	call MAINPRO
	select all
	minus Strings fileList
	Remove
endfor
select all
Remove
filedelete 'done$'
exitScript: "操作过程已结束！"+newline$

procedure MAINPRO
	editor TextGrid 'objectname$'
		a$="are shown as typed"
		b$="a single boundary"
		c$="is equal to"
		d$="some text here for green paint"
		e$="nothing"
		Preferences: "yes","no",0.05,12,"centre","'a$'","'b$'","'e$'","'c$'","'d$'"
		Spectrogram settings: 0, 5000, 0.005, 50
		Pitch settings: 100, 600, "Hertz", "autocorrelation", "automatic"
		Advanced pitch settings: 'min', 'max', "no", 15, 0.03, 0.45, 0.01, 0.35, 0.14
	endeditor
	if fileReadable("winPosition.exe")
		system "start winPosition.exe'newline$'"
	endif
	beginPause: "'f'/'fNums'  修改完TextGrid后请点击前进按钮"
		comment: "当前文件名：'objectname$'.TextGrid"
	clicked=endPause: "结束", "后退", "前进", "删除", 3
	selectObject: "TextGrid "+ objectname$
	Save as text file: texgrid_file_path$ + "/" + fName$
	filedelete 'done$'
	fileappend "'done$'" 'f''newline$'

	if clicked=2
		f=f-2
	#这里确实是f-2才能回到上一个但是我没想明白原因
	endif
	if clicked=1
		select all
		Remove
		exitScript: "操作过程已中断！"+newline$
	endif
	if clicked=4
		pause 此标注文件将被删除且不可恢复，是否继续?
		dname$=texgrid_file_path$ + "/" + fName$
		filedelete 'dname$'
	endif
	if f>fNums
		f=fNums
	endif
	if f<0
		f=0
	endif
endproc
