local R=RotationSys._strToVec{'+0+0','-1+0','-1-1','+0-1','-1+1','+1-1','+1+0','+0+1','+1+1','+0+2','-1+2','+1+2','-2+0','+2+0'}
local L=RotationSys._strToVec{'+0+0','+1+0','+1-1','+0-1','+1+1','-1-1','-1+0','+0+1','-1+1','+0+2','+1+2','-1+2','+2+0','-2+0'}
local F=RotationSys._strToVec{'+0+0','+0-1','+0+1','+0+2'}
local list={
    {[02]=L,[20]=R,[13]=R,[31]=L},--Z
    {[02]=R,[20]=L,[13]=L,[31]=R},--S
    {[02]=L,[20]=R,[13]=L,[31]=R},--J
    {[02]=R,[20]=L,[13]=L,[31]=R},--L
    {[02]=F,[20]=F,[13]=L,[31]=R},--T
    {[02]=F,[20]=F,[13]=F,[31]=F},--O
    {[02]=F,[20]=F,[13]=R,[31]=L},--I

    {[02]=L,[20]=L,[13]=R,[31]=R},--Z5
    {[02]=R,[20]=R,[13]=L,[31]=L},--S5
    {[02]=L,[20]=R,[13]=L,[31]=R},--P
    {[02]=R,[20]=L,[13]=R,[31]=L},--Q
    {[02]=R,[20]=L,[13]=L,[31]=R},--F
    {[02]=L,[20]=R,[13]=R,[31]=L},--E
    {[02]=F,[20]=F,[13]=L,[31]=R},--T5
    {[02]=F,[20]=F,[13]=L,[31]=R},--U
    {[02]=R,[20]=L,[13]=L,[31]=R},--V
    {[02]=R,[20]=L,[13]=L,[31]=R},--W
    {[02]=F,[20]=F,[13]=F,[31]=F},--X
    {[02]=L,[20]=R,[13]=R,[31]=L},--J5
    {[02]=R,[20]=L,[13]=L,[31]=R},--L5
    {[02]=L,[20]=R,[13]=R,[31]=L},--R
    {[02]=R,[20]=L,[13]=L,[31]=R},--Y
    {[02]=L,[20]=R,[13]=R,[31]=L},--N
    {[02]=R,[20]=L,[13]=L,[31]=R},--H
    {[02]=F,[20]=F,[13]=F,[31]=F},--I5

    {[02]=F,[20]=F,[13]=F,[31]=F},--I3
    {[02]=R,[20]=L,[13]=L,[31]=R},--C
    {[02]=F,[20]=F,[13]=R,[31]=L},--I2
    {[02]=F,[20]=F,[13]=F,[31]=F},--O1
}
for i=1,29 do
    local a,b=R,L
    if i==6 or i==18 then
        a,b=b,a
    end
    list[i][01]=a;list[i][10]=b;list[i][03]=b;list[i][30]=a
    list[i][12]=a;list[i][21]=b;list[i][32]=b;list[i][23]=a
end
local BiRS={
    centerTex=GC.load{10,10,
        {'setCL',1,1,1,.6},
        {'fRect',0,3,10,4},
        {'fRect',3,0,4,10},
        {'setCL',1,1,1},
        {'fRect',1,4,8,2},
        {'fRect',4,1,2,8},
        {'fRect',3,3,4,4},
    },
    data=TABLE.new(function(P,d,ifpre)
        local C=P.cur
        local idir=(C.dir+d)%4
        local kickList=list[C.id][C.dir*10+idir]
        local icb=Blocks[C.id][idir]
        local ix,iy do
            local oldSC=C.RS.centerPos[C.id][C.dir]
            local newSC=RotationSys._defaultCenterPos[C.id][idir]
            ix,iy=P.curX+oldSC[2]-newSC[2],P.curY+oldSC[1]-newSC[1]
        end
        local dx,dy=0,0 do
            local pressing=P.keyPressing
            if pressing[1] and P:ifoverlap(C.bk,P.curX-1,P.curY) then dx=dx-1 end
            if pressing[2] and P:ifoverlap(C.bk,P.curX+1,P.curY) then dx=dx+1 end
            if pressing[7] and P:ifoverlap(C.bk,P.curX,P.curY-1) then dy=  -1 end
        end
        while true do
            for test=1,#kickList do
                local fdx,fdy=kickList[test][1]+dx,kickList[test][2]+dy
                if
                    dx*fdx>=0 and
                    fdx^2+fdy^2<=5 and
                    (P.freshTime>0 or fdy<=0)
                then
                    local x,y=ix+fdx,iy+fdy
                    if not P:ifoverlap(icb,x,y) then
                        if P.gameEnv.moveFX and P.gameEnv.block then
                            P:createMoveFX()
                        end
                        P.curX,P.curY,C.dir=x,y,idir
                        C.bk=icb
                        P.spinLast=test==2 and 0 or 1

                        local t=P.freshTime
                        if not ifpre then
                            P:freshBlock('move')
                        end
                        if fdy>0 and P.freshTime==t and P.curY~=P.imgY then
                            P.freshTime=P.freshTime-1
                        end

                        local sfx
                        if ifpre then
                            sfx='prerotate'
                        elseif P:ifoverlap(icb,x,y+1) and P:ifoverlap(icb,x-1,y) and P:ifoverlap(icb,x+1,y) then
                            sfx='rotatekick'
                            P:_rotateField(d)
                        else
                            sfx='rotate'
                        end
                        if P.sound then
                            SFX.play(sfx,nil,P:getCenterX()*.15)
                        end
                        P.stat.rotate=P.stat.rotate+1
                        return
                    end
                end
            end

            --Try release left/right, then softdrop, failed to rotate otherwise
            if dx~=0 then
                dx=0
            elseif dy~=0 then
                dy=0
            else
                return
            end
        end
    end,29)
}
return BiRS
