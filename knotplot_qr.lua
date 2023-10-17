local qrencode = dofile("knotplot_qr/luaqrcode/qrencode.lua")
require("table")

function tprint (tbl, indent)
    if not indent then indent = 0 end
    local toprint = string.rep(" ", indent) .. "{\r\n"
    indent = indent + 2
    for k, v in pairs(tbl) do
      toprint = toprint .. string.rep(" ", indent)
      if (type(k) == "number") then
        toprint = toprint .. "[" .. k .. "] = "
      elseif (type(k) == "string") then
        toprint = toprint  .. k ..  "= "
      end
      if (type(v) == "number") then
        toprint = toprint .. v .. ",\r\n"
      elseif (type(v) == "string") then
        toprint = toprint .. "\"" .. v .. "\",\r\n"
      elseif (type(v) == "table") then
        toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
      else
        toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
      end
    end
    toprint = toprint .. string.rep(" ", indent-2) .. "}"
    return toprint
  end

--- The following code is used for our matrix:
---	     0 = not in use yet,
---	    -2 = blank by mandatory pattern,
---	     2 = black by mandatory pattern,
---	    -1 = blank by data,
---	     1 = black by data
function square_bin(pt)
    if (pt == -2) or (pt==-1) then
        return 0xff
    elseif (pt == 2) or (pt==1) then
        return 0x00
    else
        error()
    end
end

function append(L1,L2)
    for i=1,#L2 do  -- prints each "row" of the QR code on a line, one at a time
        L1[#L1+1]=L2[i]
    end
    return L1
end

function qr_to_bin(qr_dat)
    local bin_dat = {}

    for i=1,#qr_dat do  -- prints each "row" of the QR code on a line, one at a time
        str = ""

        for j=1,#qr_dat[i] do  -- prints each "row" of the QR code on a line, one at a time
            bin_dat[#bin_dat+1]=square_bin(qr_dat[i][j])
        end
    end
    return bin_dat
end

function write_temp(bin_dat)
    -- f = assert (io.tmpfile("wb")) -- open temporary file
    f = assert (io.open("temp.k","wb")) -- open temporary file
    -- for j=1,#qr_dat[i] do  -- prints each "row" of the QR code on a line, one at a time
    --     bin_dat[#bin_dat+1]=square_bin(qr_dat[i][j])
    -- end
    local str = string.char(table.unpack(bin_dat))
    f:write(str)
    f:close ()  -- close file
end


local header = {0x4B, 0x6E, 0x6F, 0x74, 0x50, 0x6C, 0x6F, 0x74, 0x20, 0x31, 0x2E, 0x30, 0x20, 0x20, 0x0C, 0x0A, 0x4E, 0x41, 0x4D, 0x45, 0x00, 0x00, 0x00, 0x33, 0x42, 0x61, 0x73, 0x65, 0x64, 0x20, 0x6F, 0x6E, 0x20, 0x41, 0x2E, 0x53, 0x6C, 0x6F, 0x73, 0x73, 0x20, 0x60, 0x48, 0x6F, 0x77, 0x20, 0x74, 0x6F, 0x20, 0x44, 0x72, 0x61, 0x77, 0x20, 0x43, 0x65, 0x6C, 0x74, 0x69, 0x63, 0x20, 0x4B, 0x6E, 0x6F, 0x74, 0x77, 0x6F, 0x72, 0x6B, 0x27, 0x2C, 0x20, 0x70, 0x36, 0x30, 0x43, 0x45, 0x4C, 0x54, 0x00, 0x00, 0x00, 0xB5, 0x67, 0x72, 0x69, 0x64}
local footer = {0x65, 0x6E, 0x64, 0x66, 0x0A, 0x0A, 0x0A, 0x0A}
local codeword = "a"
local bin_dat = {}
local ok, tab_or_message = qrencode.qrcode(codeword)
if not ok then
    print(tab_or_message)
else
    local n = #tab_or_message
    local size = {0x00,0x00,0x00,n,0x00,0x00,0x00,n}
    append(bin_dat,header)
    append(bin_dat,size)
    append(bin_dat,qr_to_bin(tab_or_message))
    append(bin_dat,footer)
    write_temp(bin_dat)
    -- print(tprint(bin_dat))
end