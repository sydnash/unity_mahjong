--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local proto = class("proto")
proto.length = 0

local md5 = MD5
local aes = AES
local b64 = Base64
local cvt = ByteUtils

local INT_BYTES_COUNT = 4
local CHECKSUM_LENGTH = 32

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function proto.build(command, token, acid, session, payload)
    local p = { Command   = command or string.empty, 
                RequestId = token, 
                AcId      = acid, 
                Session   = session, 
                Payload   = payload and table.tojson(payload) or string.empty,
    }

    local encrypt = table.tojson(p)
    encrypt = aes.Encrypt(encrypt .. md5.GetHash(encrypt))
    encrypt = b64.Encrypt(encrypt)
    local length = cvt.Int32ToBytes(encrypt.Length + INT_BYTES_COUNT)

    return cvt.ConcatBytes(length, length.Length, encrypt, encrypt.Length)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function proto.parse(bytes)
    if proto.buffer == nil then
        proto.buffer = bytes
    else
        proto.buffer = cvt.ConcatBytes(proto.buffer, proto.buffer.Length, bytes, bytes.Length)
    end

    if proto.length == 0 then
        if proto.buffer.Length < INT_BYTES_COUNT then
            return nil
        else
            proto.length = cvt.BytesToInt32(proto.buffer, 0)
        end
    end
    
    if proto.length > 0 and proto.length <= proto.buffer.Length then
        local bytes = cvt.SubBytes(proto.buffer, INT_BYTES_COUNT, proto.length - INT_BYTES_COUNT)
        
        proto.buffer = cvt.TrimBytes(proto.buffer, proto.length)
        proto.length = 0

        local decrypt = b64.Decrypt(bytes)
        decrypt = aes.Decrypt(decrypt)

        local len = string.len(decrypt) - CHECKSUM_LENGTH

        local data = string.sub(decrypt, 1, len)
        local hash = string.sub(decrypt, len + 1, len + CHECKSUM_LENGTH)

        if md5.GetHash(data) ~= hash then
            log("checksum of msg is wrong!")
            return nil
        end

        return table.fromjson(data)
    end
end

return proto

--endregion
