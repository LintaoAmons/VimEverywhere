if true then return {} end

return {
  "robitx/gp.nvim",
  config = function()
    local conf = {
      -- For customization, refer to Install > Configuration in the Documentation/Readme
      --
      providers = {
        openai = {
          endpoint = "http://" .. os.getenv("OPENAI_DOMAIN") .. "/v1/chat/completions",
          secret = os.getenv("OPENAI_API_KEY"),
        },
        anthropic = {
          endpoint = "https://" .. os.getenv("ANTHROPIC_DOMAIN") .. "/v1/messages",
          secret = os.getenv("ANTHROPIC_API_KEY"),
        },
      },
      agents = {
        -- {
        --   provider = "openai",
        --   name = "ChatGPT4o-mini-lintao",
        --   chat = true,
        --   command = false,
        --   -- string with model name or table with model name and parameters
        --   model = { model = "gpt-4o-mini", temperature = 1.1, top_p = 1 },
        --   -- system prompt (use this to specify the persona/role of the AI)
        --   system_prompt = require("gp.defaults").chat_system_prompt,
        -- },
        {
          provider = "anthropic",
          name = "ChatClaude-3-Haiku",
          chat = true,
          command = false,
          -- string with model name or table with model name and parameters
          model = { model = "claude-3-haiku-20240307", temperature = 0.8, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = require("gp.defaults").chat_system_prompt,
        },
      },
      hooks = {
        EnglishPractice = function(gp, params)
          local template = [[
              我希望你扮演我的英语老师，给我出一些适用于日常交流的中文到英文翻译题目。
              在我提供翻译答案后，请分析并指出我的错误，同时提出实用的改进建议，
              以帮助我提高我的英语表达能力，而不是单纯的考试翻译技巧。
              同时还需要给出你觉得更简练自然日常口语化的句子，不局限于我给出的翻译，并给出解释.
              题目的话题或主题应该在大范围内随机生成，
              题目的句型与语法特点也应有变化,并在解释的时候说明考察的句型和语法特点.
              我发出start指令后，从你开始给出随机的题目,句子构成以及难度应该偏难，以长句为主,
              每一轮解释结束后直接给出下一轮的句子
            ]]
          gp.cmd.ChatNew(params, template)
        end,
        Xiaohongshu = function(gp, params)
          local template = [[
              请用代码片段的形式总结一个编程主题，编程主题我会在后续的聊天中提供，遵循以下要求：

              1. 每个代码片段应紧凑并包含约10行代码。代码最好只占用一行，但是如果无法实现功能，则可以将其拆分为多行。
              2. 每行代码应附带注释，说明代码的作用及其含义。注释最好在代码同一行，但是如果无法实现功能，则可以将其拆分为多行。
              3. 请确保代码示例是可运行的。
              4. 结构清晰，便于我理解和学习。
            ]]
          gp.cmd.ChatNew(params, template)
        end,
        MarkdownRefine = function(gp, params)
          local template = [[
              - 检查内容，并用 markdown 的格式修复部分缺失的格式
              - 不能对内容进行大面积修改或总结，保持原有内容内容
            ]]
          gp.cmd.ChatNew(params, template)
        end,
      },
    }
    require("gp").setup(conf)

    -- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
  end,
}
