function [] = ttest()
  keys = [1, 2, 3, 4, 5];
  values = [11, 22, 33, 44, 55];
  
  map_val = CreateValueMap(keys,values);
  map_size = GetMapSize(map_val);
  
  map_val = PutMapValue(map_val,8,88);
  asdf = GetMapValue(map_val,8);
  
  map_size2 = GetMapSize(map_val);
  
end