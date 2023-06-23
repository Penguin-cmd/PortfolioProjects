from math import sqrt
from csv import reader 

#loads csv file
def load_csv(filename):
    dataset=list()
    with open(filename, 'r') as file:
        csv_reader = reader(file)
        for row in csv_reader:
            if not row:
                continue
            dataset.append(row)
        return dataset

#convert string to float value
def str_to_float(dataset,column):
    for row in dataset:
        row[column] = float(row[column].strip())
         
#used to calculate euclidean distance between two vectors 
def euclidean_distance(p , q):
    distance=0.0
    for i in range (len(p)-1):
        distance+=(p[i] - q[i])**2
    return sqrt(distance)


#locate most similar neighbors
def get_neighbors(train,test_row, num_neighbors):
    distances = list()
    for train_row in train:
        dist = euclidean_distance(test_row,train_row)
        distances.append((train_row,dist))
    distances.sort(key=lambda tup: tup[1])
    neighbors = list()
    for i in range(num_neighbors):
        neighbors.append(distances[i][0])
    return neighbors

#makes our predictions 
def predict_classification(train, test_row, num_neighbors):
        neighbors = get_neighbors(train, test_row, num_neighbors)
        output_values = [row[-1] for row in neighbors]
        prediction = max(set(output_values), key= output_values.count)
        return prediction

#finds min and max in each column
def minmax(dataset):
    minmax=list()
    for i in range(len(dataset[0])):
        col_values = [row[i] for row in dataset]
        value_min=min(col_values)
        value_max=max(col_values)
        minmax.append([value_min,value_max])
    return minmax

#function to normalize data
def normalization (dataset,minmax):
    for row in dataset:
        for i in range(len(row)):
            row[i]=(row[i]-minmax[i][0])/(minmax[i][1]-minmax[i][0])

#function to calculate accuracy 
def accuracy_metric(actual,predicted):
    correct=0
    for i in range(len(actual)):
        if actual[i] == predicted[i]:
            correct+=1
        return correct / float(len(actual))*100


#load datasets
dataset_p = load_csv('test.csv')
dataset_q= load_csv('train.csv')  
print('Loaded data files')

#convert strings to numeric values
for i in range(len(dataset_p[0])):
    str_to_float(dataset_p, i)
for i in range(len(dataset_p[0])):
    str_to_float(dataset_q,i)
print('String values converted to float values') 

#normalize datasets   
normalization(dataset_p, minmax(dataset_p))
normalization(dataset_q, minmax(dataset_q))
print('Datasets normalized')


label=list()
for i in range(len(dataset_p)):
   label.append(predict_classification(dataset_q, dataset_p[i], 50))
print('Predicted values:',label)


    
      
      
      
      