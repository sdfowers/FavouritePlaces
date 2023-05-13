Sean Fowers - s5181954
3701ICT - Tri 1 2023

#  Assignment 2
## Milestone 1
I've learned how to utilise coreData and its simplicity. I've also learned how to use the database system model, adding pictures and downloading them from the internet, and some styling techniques for xcode.

## Milestone 2
Map is fully functional. Address, latitude and longitude save to file and when reopened the user will be returned to the same position. There was some difficulty with ordering the map functionality, as some functions are called through other functions, but following the logic i found my issues after some study.
Another issue i found was my ContentView would only update if i changed the imageURL. I went through numerous changes to finally notice that my RowView page did not have an @ObservedObject tag on the place variable. Once added, the contentview began updating as you would expect. Now any changes are able to be seen from every other page so long as they have been saved.
