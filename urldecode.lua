function decodeURI(str)
  if(str) then
    str = string.gsub(str, '%%(%x%x)',
      function (hex) return string.char(tonumber(hex,16)) end )
  end
  return str
end
