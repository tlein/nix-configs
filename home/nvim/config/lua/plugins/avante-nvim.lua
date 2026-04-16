require('avante_lib').load()
require('avante').setup({
  provider = 'ollama',
  vendors = {
    ollama = {
      __inherited_from = 'openai',
      api_key_name = '',
      endpoint = 'http://127.0.0.1:11434/v1',
      model = 'llama3.2',
      disable_tools = true, -- Open-source models often do not support tools.
    },
  },
})
