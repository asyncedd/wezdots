merge = function(tbl1, tbl2)
  for k, v in pairs(tbl2) do
    if type(v) == "table" then
      if type(tbl1[k] or false) == "table" then
        tbl1[k] = merge(tbl1[k] or {}, tbl2[k] or {}) -- Corrected recursive call
      else
        tbl1[k] = v
      end
    else
      tbl1[k] = v
    end
  end
  return tbl1
end

return merge
