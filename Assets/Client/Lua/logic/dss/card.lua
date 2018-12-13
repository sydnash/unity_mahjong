
local card = class("card", base)

function card.typeId(card) 
    return math.floor(card / 4)
end

return card