---@type Map<Techmino.Event.Acry>
local mergeSys={}

function mergeSys.modern(P,g,maxLen,lineCount)
    if maxLen>3 then
        -- Single line
        if maxLen==4 then
            return {
                color=g.color,
                appearance='flame',
                destroyed={
                    mode='explosion',
                    radius=1,
                }
            }
        elseif maxLen==5 then
            return {
                type='cube',
                moved='destroy',
                destroyed={
                    mode='color',
                }
            }
        else
            return {
                color=g.color,
                appearance='nova',
                destroyed={
                    mode='lightning',
                    radius=1,
                }
            }
        end
    else
        -- Star
        if lineCount>1 then
            return {
                color=g.color,
                appearance='star',
                destroyed={
                    mode='lightning',
                    radius=0,
                }
            }
        end
    end
end

return mergeSys
