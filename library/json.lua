--- @meta
--- json.lua - Provides JSON encoding and decoding functionalities.

local json = {}

--- @type string The version of the json library.
json._version = "0.1.2"

--- Encodes a Lua value into a JSON string.
--- Supports tables (as arrays or objects), strings, numbers, booleans, and nil.
--- @param val any The Lua value to encode. Tables can be arrays or objects.
--- @return string The JSON string representation of the value.
--- @raise "circular reference" if a circular table reference is detected.
--- @raise "invalid table: mixed or invalid key types" if a table intended as an array has non-numeric keys or a table intended as an object has non-string keys.
--- @raise "invalid table: sparse array" if a table intended as an array is sparse.
--- @raise "unexpected number value 'NaN'" if a number is NaN, -Infinity, or +Infinity.
--- @raise "unexpected type 'function'" if an unsupported type (e.g., function, userdata, thread) is provided.
function json.encode(val) end

--- Decodes a JSON string into a Lua value.
--- @param str string The JSON string to decode.
--- @return any The Lua value represented by the JSON string.
--- @raise "expected argument of type string, got ..." if the input is not a string.
--- @raise "unexpected character '...'" if an invalid character is encountered.
--- @raise "control character in string" if an unescaped control character is found in a string.
--- @raise "invalid unicode escape in string" if a malformed Unicode escape sequence is found.
--- @raise "invalid escape char '...' in string" if an unrecognized escape character is found.
--- @raise "expected closing quote for string" if a string literal is not properly terminated.
--- @raise "invalid number '...'" if a number literal is malformed.
--- @raise "invalid literal '...'" if an unrecognized literal (e.g., not 'true', 'false', 'null') is found.
--- @raise "expected ']' or ','" if an array is malformed.
--- @raise "expected '}' or ','" if an object is malformed.
--- @raise "expected string for key" if an object key is not a string literal.
--- @raise "expected ':' after key" if a colon is missing after an object key.
--- @raise "trailing garbage" if there are characters after the main JSON value.
function json.decode(str) end

return json
