local C2_sym={}
C2_sym.centerPreset='common'
C2_sym.centerTex=GC.load{10,10,
    {'setLW',2},
    {'dRect',2,2,6,6},
}
local L={'+0+0','-1+0','+1+0','+0-1','-1-1','+1-1','-2+0','+2+0'}
local R={'+0+0','+1+0','-1+0','+0-1','+1-1','-1-1','+2+0','-2+0'}
local Z={
    [0]={R={test=R},L={test=L},F={test=R}},
    [1]={R={test=R},L={test=L},F={test=L}},
    [2]={R={test=R},L={test=L},F={test=L}},
    [3]={R={test=R},L={test=L},F={test=R}},
}
local S=MinoRotSys._reflect(Z)
C2_sym[1]=Z-- Z
C2_sym[2]=S-- S
C2_sym[3]=Z-- J
C2_sym[4]=S-- L
C2_sym[5]=Z-- T
C2_sym[6]=Z-- O
C2_sym[7]=Z-- I
C2_sym[8]=Z-- Z5
C2_sym[9]=S-- S5
C2_sym[10]=Z-- P
C2_sym[11]=S-- Q
C2_sym[12]=Z-- F
C2_sym[13]=S-- E
C2_sym[14]=Z-- T5
C2_sym[15]=Z-- U
C2_sym[16]=Z-- V
C2_sym[17]=Z-- W
C2_sym[18]=Z-- X
C2_sym[19]=Z-- J5
C2_sym[20]=S-- L5
C2_sym[21]=Z-- R
C2_sym[22]=S-- Y
C2_sym[23]=Z-- N
C2_sym[24]=S-- H
C2_sym[25]=Z-- I5
C2_sym[26]=Z-- I3
C2_sym[27]=Z-- C
C2_sym[28]=Z-- I2
C2_sym[29]=Z-- O1
return C2_sym
