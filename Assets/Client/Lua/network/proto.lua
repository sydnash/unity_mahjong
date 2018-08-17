--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local proto = class("proto")

local md5 = MD5
local aes = AES
local b64 = Base64
local cvt = DataConvert

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

    return cvt.ConcatBytes(length, encrypt)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function proto.parse(msg)
    if msg == nil or msg.Length <= INT_BYTES_COUNT then
        return nil
    end

    local decrypt = b64.Decrypt(msg)
    decrypt = aes.Decrypt(decrypt)

    local length = string.len(decrypt) - CHECKSUM_LENGTH

    local data = string.sub(decrypt, 1, length)
    local checkSum = string.sub(decrypt, length + 1, length + CHECKSUM_LENGTH)

    if md5.GetHash(data) ~= checkSum then
        log("checksum of msg is wrong!")
        return nil
    end

    return table.fromjson(data)
end

return proto

--endregion
