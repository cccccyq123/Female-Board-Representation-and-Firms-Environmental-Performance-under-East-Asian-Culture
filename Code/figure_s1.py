#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Mar 18 16:56:43 2025

@author: chenyuqi
"""

import pandas as pd
import matplotlib.pyplot as plt

plt.rcParams['font.family'] = 'Arial'
file_path = 'figure-s1.xlsx' 
df = pd.read_excel(file_path)
plt.figure(figsize=(10, 6))
df_us = df[df['region'] == 'The U.S.']
df_europe = df[df['region'] == 'Europe']
df_asia = df[df['region'] == 'East Asia']
df_us.set_index('year', inplace=True)
df_europe.set_index('year', inplace=True)
df_asia.set_index('year', inplace=True)
df_us['female director'].plot(marker='o', linestyle='-', color='red', label='The U.S.', fontsize=12)
df_europe['female director'].plot(marker='s', linestyle=':', color='green', label='Europe', fontsize=12)
df_asia['female director'].plot(marker='^', linestyle='--', color='blue', label='East Asia', fontsize=12)
plt.xticks([2017, 2018, 2019, 2020, 2021], fontsize=12)
plt.ylim(0, 40)
plt.yticks(fontsize=12)
plt.xlabel('Year', fontsize=12)
plt.ylabel('Average Percentage of Female Directors on Boards', fontsize=12)
plt.legend(loc='upper center', bbox_to_anchor=(0.5, -0.15), ncol=3)
plt.savefig('fig-s1.png', dpi=300, bbox_inches='tight')