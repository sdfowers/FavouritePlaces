Sean Fowers - s5181954
3701ICT - Tri 1 2023

#  Assignment 2
## Milestone 1
I've learned how to utilise coreData and its simplicity. I've also learned how to use the database system model, adding pictures and downloading them from the internet, and some styling techniques for xcode.

## Milestone 2
Map is fully functional. Address, latitude and longitude save to file and when reopened the user will be returned to the same position. There was some difficulty with ordering the map functionality, as some functions are called through other functions, but following the logic i found my issues after some study.
Another issue i found was my ContentView would only update if i changed the imageURL. I went through numerous changes to finally notice that my RowView page did not have an @ObservedObject tag on the place variable. Once added, the contentview began updating as you would expect. Now any changes are able to be seen from every other page so long as they have been saved.

## Milestone 3
Everyone functions correctly without issue. I've also added map annotation so you can navigate to each place from the map itself. There was some difficulty getting the API working correctly for the sunset/sunrise but it hasn't had any issues since. The map has been the most difficult part of this assignment, but after reviewing the course content and the examples i was able to figure out my problems.
I haven't been able to implement tests very well as i've run out of time and have had major difficulty accessing coredata or the mapmodels methods. I'll take the loss on this though and will have to develop better testing skills in general as that feels like the area i'm struggling with the most in this class.
Thanks Larry/Tanzima, you've been great and very helpful!

Video Link:

