local Case = {}

function Case:snake_to_camel(input): string
  return string.gsub(input, "_(.)", string.upper)
end

function Case:snake_to_pascal(input): string
  return string.gsub("_"..input, "_(.)", string.upper):sub(1)
end

function Case:snake_to_kebab(input): string
  return string.gsub(input, "(_)", "-")
end

function Case:snake_to_prop(input): string
  return string.gsub(input, "(_)", ".")
end

function Case:snake_to_title(input): string
  return input:gsub("(_)", " "):gsub("%f[%a].", string.upper)
end

function Case:prop_to_path(input): string
  return string.gsub(input, "([\.])", "/")
end

function Case:prop_to_snake(input): string
  return string.gsub(input, "([\.])", "_")
end

return Case
