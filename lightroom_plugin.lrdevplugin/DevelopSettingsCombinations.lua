-- https://stackoverflow.com/questions/58668988/find-all-possible-combination-of-these-two-sets-of-items-lua
-- combine arrays recursively
-- table array: { {1, 2}, {3, 4}, {5, 6} }
-- Should return { 135, 136, 145, 146, 235, 236, 245, 246 }
--
-- This uses tail recursion so hopefully lua is smart enough not to blow the stack
local combine = {}
function arrayCombine(tableArray)
    -- Define the base cases
    if (tableArray == nil) then
        return nil
    elseif (#tableArray == 0) then
        return {}
    elseif (#tableArray == 1) then
        return tableArray[1]
    elseif (#tableArray == 2) then
        return arrayCombine2(tableArray[1], tableArray[2])
    end -- if

    -- We have more than 2 tables in the input parameter.  We want to pick off the *last*
    -- two arrays, merge them, and then recursively call this function again so that we
    -- can work our way up to the front.
    local lastArray = table.remove(tableArray, #tableArray)
    local nextToLastArray = table.remove(tableArray, #tableArray)
    local mergedArray = arrayCombine2(nextToLastArray, lastArray)

    table.insert(tableArray, mergedArray)

    return arrayCombine(tableArray)
end


function arrayCombine2(array1, array2)
    local mergedArray = {}
    for _, elementA in ipairs(array1) do
        for _, elementB in ipairs(array2) do
            table.insert(mergedArray, elementA..","..elementB)
        end
    end

    return mergedArray
end

-- function to split string in table
-- source for this code snippet: 
-- https://www.codegrepper.com/code-examples/lua/lua+split+string+by+delimiter
local function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

-- the following code was added by the teamproject group:
function combine.getCombinedArray(array)
    combinedArray = {}
    for keys, v in pairs(array) do
        table.insert(combinedArray, array[keys])
    end
    return combinedArray
end

function combine.getTimesOfCombinations(array)
    times = 1
    for key, v in pairs(array) do
        times = times * #array[key]
    end
    return times
end


function combine.getSettingsTable(array)
    settingsTable = {}
    for key,v in pairs(arrayCombine(array)) do
        settingsTable[key] = Split(v,",")
    end
    return settingsTable
end

-- save all setting-keys in keyset for later use
function combine.getKeys(array)
    n = 0
    keyset = {}
    for k,v in pairs(array) do
        n=n+1
        keyset[n]=k
    end
    return keyset
end

return combine
