# -*- coding: utf-8 -*-
"""
Created on Sun Oct 27 22:14:39 2019

@author: soumya.ghosh
"""

# -*- coding: utf-8 -*-
"""
Created on Sun Oct 27 21:27:02 2019

@author: soumya.ghosh
"""

import pandas as pd
import numpy as np

# Dash related libraries
import dash
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output
import plotly.graph_objs as go
import plotly as plotly

#url = 'https://data.cityofnewyork.us/resource/uvpi-gqnh.json'
#trees = pd.read_json(url)
#trees.head(10)

# Aggregate the tree count by Borough, Species and Health condition 
soql_url = ('https://data.cityofnewyork.us/resource/uvpi-gqnh.json?$limit=50000&' +\
        '$select=boroname,spc_common,health,steward,count(tree_id)' +\
        '&$group=boroname,spc_common,health,steward' +\
        '&$order=boroname,spc_common,health,steward').replace(' ', '%20')
trees_summary = pd.read_json(soql_url)
trees_summary['health'] = trees_summary['health'].fillna('Fair')
trees_summary['steward'] = trees_summary['steward'].fillna('None')
#trees_summary

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

#server = app.server

boroughs = trees_summary['boroname'].unique()
species = trees_summary['spc_common'].unique()
stewards = trees_summary['steward'].unique()

app.layout = html.Div([html.H1(children = 'NYC Street Tree Health'),
    html.P('These graphics display the overall health of trees along city streets in NYC.'),
    html.H2(children = 'NYC Street Tree Health Proportion By Borough & Species'),
    html.P('Please select a Borough and a Species: '),
    html.Div([
        dcc.Dropdown(
            id='boro-selector',
            options=[{'label': i, 'value': i} for i in boroughs],
            value='Bronx'
        ),
        dcc.Dropdown(
            id='species-selector',
            options=[{'label': i, 'value': i} for i in species],
            value='American beech'
        )
    ],style={'width': '50%', 'display': 'inline-block', 'padding':0}),
    html.Div([html.P(id='param-select')]),
    html.Div([
        dcc.Graph(id='output-health-proportion')
    ]),
    html.H2(children = 'NYC Street Tree Health By Stewardship'),
    html.Div([
        dcc.RadioItems(
            id='steward-selector',
            options=[{'label': i, 'value': i} for i in stewards],
            value='None'
        )]),
    html.Div([
        dcc.Graph(id='output-steward-hist')
    ])   
    
])

@app.callback(
    dash.dependencies.Output('param-select', 'children'),
    [dash.dependencies.Input('boro-selector', 'value'),
    dash.dependencies.Input('species-selector', 'value')])
def update_output(boroname, species):
    return u'Borough :"{}", Speceies :"{}"'.format(boroname, species)

@app.callback(
    dash.dependencies.Output('output-health-proportion', 'figure'),
    [dash.dependencies.Input('boro-selector', 'value'),
    dash.dependencies.Input('species-selector', 'value')])
def update_graph(boroname, species):
    dff = trees_summary[(trees_summary['boroname'] == boroname) & (trees_summary['spc_common'] == species)]
    return {
           'data': [go.Pie(labels = dff['health'],values = dff['count_tree_id'], name='HealthProportion')],
           'layout': [go.Layout(title = 'Health Proportion: "{}" Borough & "{}" Species'.format(boroname,species),
                            margin={'l': 100, 'b': 200, 't': 10, 'r': 10},
                            height=1000,
                            hovermode='closest')]
            }


@app.callback(
    dash.dependencies.Output('output-steward-hist', 'figure'),
    [dash.dependencies.Input('boro-selector', 'value'),
    dash.dependencies.Input('species-selector', 'value'),
    dash.dependencies.Input('steward-selector', 'value')])
def steward_graph(boroname, species, steward):
    df = trees_summary[(trees_summary['boroname'] == boroname) & 
                       (trees_summary['spc_common'] == species) & 
                       (trees_summary['steward'] == steward)]
    
    return {
            'data':[go.Bar(name=steward, x=df['health'],y=df['count_tree_id'])],
            'layout':{'title':"Health by Stewardship"}
            }
            
if __name__ == '__main__':
    app.run_server(debug=False)