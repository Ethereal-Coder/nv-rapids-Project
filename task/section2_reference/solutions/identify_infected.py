infected_cluster = dbscan.fit_predict(gdf.loc[gdf['infected'] == 1, ['northing', 'easting']])
gdf['cluster'] = dbscan.labels_
print(f'{len(dbscan.labels_.unique())} distinct clusters of infected found')
