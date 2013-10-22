TestApp
=======

TestApp - Fetch XML from iTunes via NSXMLParser: http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topsongs/limit=10/xml

The application consist of two view controllers.

1. Data from the iTunes service is parsed using NSXMLParser.
2. The song title,the link to the album image and the song's web link
are saved using Core Data.
3. The saved data from the Core Data is displayed to the user using
UITableView.
4. App is usable (info accessible) if there is not data connection.
5. Each cell in the UITableView contains title label of the song and
the cover image.
6. App uses custom UITableViewCell; the data is updated via custom
method.
7. All the data is loaded asynchronously (by using queuing mechanisms)
to maintain responsive user interface.
8. When user selects the cell, a new view controller is  shown.
9. The new view controller contains album artwork which can be
zoomed-in/zoomed-out using pinch gestures.
10. By clicking on the album artwork, user is navigated to the iTunes
application and shown the selected song.
11. All the views are made in code (no usage of Interface Builder
and/or Storyboards).
12. MVC architecture principles has being followed.
13. App supports iOS6 and iOS7.

Extras.
1. Usage of progress indicator for fetching and preparing data
2. Usage of SOLID design.
3. Usage of Cocoapods.
