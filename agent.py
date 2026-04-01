from langchain.agents import create_agent
from langchain.messages import HumanMessage
from langchain_ollama import ChatOllama

from prompt import PROMPT
from tools import get_line_information

# instantiate the model
# temperature is effectively the level of 'creativity' 
local_llm = "qwen3.5:2b"
llm  = ChatOllama(model = local_llm, temperature = 0)

# if you want your llm to respond with json
#llm_json_mode = ChatOllama(model = local_llm, temperature = 0, format='json')

# Create an agent with the defined llm
# Attach the tools you wish to use, usually python functions
# The prompt is key for telling the agent it's workflow and how to behave
agent = create_agent(
    model=llm,
    tools=[get_line_information],
    system_prompt=PROMPT)

# Messages will hold our conversation history, the llm will need this to reason
# Advanced models will need to be trimmed or summarised
messages = []
while True:
    # Capture input from the terminal
    # Add it to the message history and tag as human
    # Will help llm to know which are human messages and which are its own
    user_input = input("Input: ")
    messages.append(HumanMessage(user_input))
    
    # Pass it to the agent
    response = agent.invoke({"messages": messages})

    # Output the whole conversation, good for debugging
    #print(response)

    # Output the latest message from the LLM
    print(response['messages'][-1].content) 

    messages.append(response)
