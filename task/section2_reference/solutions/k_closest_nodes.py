distances, indices = knn.kneighbors(hospitals[['easting', 'northing']], 3) # order has to match the knn fit order (east, north)
distances = distances ** (1/2) # distances are returned as the square of the actual distance, so we adjust here
