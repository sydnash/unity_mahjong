--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local networkConfig = require("config.networkConfig")

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
    encrypt = encrypt .. md5.GetHash(encrypt)

    if networkConfig.encrypt then
        encrypt = aes.Encrypt(encrypt)
        encrypt = b64.Encrypt(encrypt, 0, encrypt.Length)
        local length = cvt.Int32ToBytes(encrypt.Length + INT_BYTES_COUNT)

        return cvt.ConcatBytes(length, length.Length, encrypt, encrypt.Length)
    end

    local length = cvt.Int32ToBytes(string.len(encrypt) + INT_BYTES_COUNT)
    return cvt.ConcatBytes(length, length.Length, cvt.StringToBytes(encrypt), string.len(encrypt))
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function proto.parse(bytes)
    if bytes.Length >= INT_BYTES_COUNT then            
        local length = cvt.BytesToInt32(bytes, 0)
    
        if length <= bytes.Length then
            local decrypt = nil

            if networkConfig.encrypt then
                decrypt = b64.Decrypt(bytes, INT_BYTES_COUNT, length - INT_BYTES_COUNT)
                decrypt = aes.Decrypt(decrypt)
            else
                decrypt = cvt.BytesToString(bytes, INT_BYTES_COUNT, length - INT_BYTES_COUNT)
            end

            local size = string.len(decrypt) - CHECKSUM_LENGTH
            local data = string.sub(decrypt, 1, size)
            local hash = string.sub(decrypt, size + 1, size + CHECKSUM_LENGTH)

            if md5.GetHash(data) ~= hash then
                log("checksum of msg is wrong!")
                return nil, length
            end

            return table.fromjson(data), length
        end
    end

    return nil, 0
end

return proto

--endregion
