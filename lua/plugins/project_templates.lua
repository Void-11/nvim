return {
  -- Project templates and language-specific snippets/scaffolding
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets", "saadparwaiz1/cmp_luasnip" },
    config = function()
      local ls = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node

      -- Next.js page component (TSX)
      ls.add_snippets("typescriptreact", {
        s("nextpage", {
          t("import React from 'react'\n"),
          t("export default function "), i(1, "Page"), t({"() {","  return (","    <div className=\"\">"}), i(2, "Hello"), t({"</div>","  )","}"}),
        }),
      })

      -- Node.js Express boilerplate
      ls.add_snippets("javascript", {
        s("express", {
          t({"const express = require('express');","const app = express();","app.use(express.json());","","app.get('/', (req, res) => {","  res.send('OK');","});","","app.listen("}), i(1, "3000"), t(", () => console.log('Server running'));"),
        }),
      })

      -- Python ML script template
      ls.add_snippets("python", {
        s("mlscript", {
          t({"import numpy as np","import torch","import torch.nn as nn","import librosa","","def main():","  pass","","if __name__ == '__main__':","  main()"}),
        }),
      })

      -- C++ main
      ls.add_snippets("cpp", {
        s("main", { t({"#include <bits/stdc++.h>","using namespace std;","","int main(int argc, char** argv){","  ios::sync_with_stdio(false);","  cin.tie(nullptr);","  ",}), i(1, "// code"), t({"","  return 0;","}"}), }),
      })

      -- Unreal Engine 5 snippets (available in any C++ buffer)
      ls.add_snippets("cpp", {
        -- UE5 UCLASS
        s("uclass", {
          t("UCLASS("), i(1, "BlueprintType"), t(")"), t({"", "class "}),
          f(function()
            if _G.get_ue5_project_name then
              local n = _G.get_ue5_project_name() or "PROJECT"
              return string.upper(n) .. "_API"
            end
            return "PROJECT_API"
          end),
          t(" U"), i(2, "ClassName"), t(" : public "), i(3, "UObject"), t({"", "{", "\tGENERATED_BODY()", "", "public:", "\tU"}),
          f(function(args) return args[1][1] end, {2}), t("();"), t({"", "", "protected:", "\t"}), i(4, "// Protected members"),
          t({"", "", "private:", "\t"}), i(5, "// Private members"), t({"", "};"}),
        }),
        -- UE5 USTRUCT
        s("ustruct", {
          t("USTRUCT("), i(1, "BlueprintType"), t(")"), t({"", "struct "}),
          f(function()
            if _G.get_ue5_project_name then
              local n = _G.get_ue5_project_name() or "PROJECT"
              return string.upper(n) .. "_API"
            end
            return "PROJECT_API"
          end),
          t(" F"), i(2, "StructName"), t({"", "{", "\tGENERATED_BODY()", "", "\t"}), i(3, "// Struct members"), t({"", "};"}),
        }),
        -- UE5 UENUM
        s("uenum", {
          t("UENUM("), i(1, "BlueprintType"), t(")"), t({"", "enum class E"}), i(2, "EnumName"), t(" : uint8"),
          t({"", "{", "\t"}), i(3, "None"), t(" UMETA(DisplayName = \""), f(function(args) return args[1][1] end, {3}), t("\"),"),
          t({"", "\t"}), i(4, "// Additional enum values"), t({"", "};"}),
        }),
        -- UE5 UPROPERTY
        s("uprop", { t("UPROPERTY("), i(1, "EditAnywhere, BlueprintReadWrite"), t(")"), t({"", ""}), i(2, "FString"), t(" "), i(3, "PropertyName"), t(";") }),
        -- UE5 UFUNCTION
        s("ufunc", { t("UFUNCTION("), i(1, "BlueprintCallable"), t(")"), t({"", ""}), i(2, "void"), t(" "), i(3, "FunctionName"), t("("), i(4), t(");") }),
      })
    end,
  },
}

