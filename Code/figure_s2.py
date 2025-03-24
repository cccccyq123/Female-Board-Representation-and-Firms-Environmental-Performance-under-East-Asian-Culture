#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Mar 18 16:58:25 2025

@author: chenyuqi
"""

import pandas as pd
import matplotlib.pyplot as plt

plt.rcParams['font.family'] = 'Arial'
file_path = 'figure-s2.xlsx'
df = pd.read_excel(file_path)
df_grouped = df[['NATION', 'FD']].groupby('NATION').mean().sort_values(by='FD', ascending=False)
plt.figure(figsize=(10, 6))
ax = df_grouped.plot(kind='bar', legend=False, edgecolor='#4682B4', facecolor='none')
plt.ylim(0, 50)
plt.xlabel('', fontsize=6) 
plt.ylabel('Average Percentage of Female Directors on Boards', fontsize=8, fontweight='normal')  # Y轴标签字体大小
plt.xticks(rotation=45, ha='right', fontsize=8)
plt.yticks(fontsize=8)
plt.savefig('fig-s2.png', dpi=300, bbox_inches='tight')