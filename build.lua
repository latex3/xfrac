-- Build script for "xfrac" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
module = "xfrac"

-- Detail how to set the version automatically

tagfiles = {"*.dtx","*.md"}

function update_tag(file,content,tagname,tagdate)
    local iso = "%d%d%d%d%-%d%d%-%d%d"
  
    if string.match(file,"CHANGELOG.md") then
      -- CHANGELOG.md
      local url = "https://github.com/latex3/xfrac/compare/"
      local previous = string.match(content,"compare/(" .. iso .. ")%.%.%.HEAD")
      if tagname == previous then return content end
      content = string.gsub(content,
        "## %[Unreleased%]",
        "## [Unreleased]\n\n## [" .. tagname .."]")
      return string.gsub(content,
        iso .. "%.%.%.HEAD",
        tagname .. "...HEAD\n[" .. tagname .. "]: " .. url .. previous
          .. "..." .. tagname)
    elseif string.match(file,"README.md") then
        return string.gsub(content,"Release " .. iso,"Release " .. tagname)
    else
      -- xfrac.dtx
      content = string.gsub(content,
      "\n\\ProvidesExpl" .. "(%w+ *{[^}]+} *){" .. iso .. "}",
      "\n\\ProvidesExpl%1{" .. tagname .. "}")
      return string.gsub(content,
        "\n%% \\date{Released " .. iso .. "}\n",
        "\n%% \\date{Released " .. tagname .. "}\n")
    end
  end

  function tag_hook(tagname)
    os.execute('git commit -a -m "Step release tag"')
    os.execute('git tag -a -m "" ' .. tagname)
  end
  