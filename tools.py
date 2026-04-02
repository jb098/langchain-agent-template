import requests

from langchain.tools import tool

# We tag the function as a tool so langchain knows to analyse this and let the llm work out how best to call it
# It's important to be descriptive here in a few places so the llm can get the correct context
# 1. Name the function sensibly, making sure it describes well what the function does
# 2. Name the passed variables correctly and correctly assign the type
# 3. Be very very descriptive about what the function does and what it returns


@tool()
def get_line_information(line: str):
    """
    A function designed to retrieve information on a given public transport line in London. The argument line could be a tube line, a bus route or other named line. Examples of the line argument might be something like 'central' or 'piccadilly', while bus lines will be something like 'N11'.

    :returns: A dictionary containing information about the transport line such as the mode of transport, any potential disruptions, the status of the lines and the service type i.e. what times of the day it runs. 
    """
    return requests.get("https://api-tigris.tfl.gov.uk/Line/{}".format(line)).json()
    

