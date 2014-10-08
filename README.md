iFindArtist
===========

iFindArtist uses Flickr's API to explore and search photos using Stanford's Flickr Example expanded more

The aim of the project is to find budding artist trying to post their pictures publically and with Flickr APIs, I managed to get photographers of a particular location my doing a simple location search according to the latitude and longitude of the phone. 
 
Some additional features added from the first release is search, one can instantly search Flickr Database to find cool pictures according to text inputted in the search field. 
If he likes the photograph, one can just hold the photo until a share menu comes up to prompt him to email him the picture to save to his device or Airdrop to his/her friends.
 
The man feature added and still under development is the iBeacon feature. Trying to use Bluetooth as its channel, an Artist can broadcast his/her signal; with use of Bluetooth find other people trying to connect with you. 
 
The App was aimed to just enhance photographers to reach out and this will be kept on improving to provide better and more functionality.

I used a lot of help from various websites and have quoted them inside the code for someone to refer it.

## Some References
1. AGPhotobrowser - https://github.com/andreagiavatto/AGPhotoBrowser/blob/master/LICENSE.md
2. AppCoda 

## Main Menu with Scrollable Background (ScrollView dynamically increasing its size to fit a few photographs)
![Alt text](/images/find1.png?raw=true)
![Alt text](/images/find2.png?raw=true)

##Explore Button opens this view from from current latitude and longitude these list of artists are displayed in the table view
![Alt text](/images/find3.png?raw=true)

##Pull down to refresh option has also been implemented
![Alt text](/images/find4.png?raw=true)

##Custom UITableViewCell to show photographs of photographer (loads the photo from Flickr in another thread and dispatches it to main thread for graphic rendering)
![Alt text](/images/find5.png?raw=true)

##AGPhotobrowser used here (open source github repo) - https://github.com/andreagiavatto/AGPhotoBrowser/blob/master/LICENSE.md

Had edited parts of AGPhotobrowser to workaround some issues displaying photos in sync (by loading it from Flickr in different thread and pass it to main thread)

For Sharing used this piece of code

'''    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];'''
![Alt text](/images/find6.png?raw=true)

##Implemented the sharing button in AGPhotobrowser using native API to call all the sharing and saving options

![Alt text](/images/find7.png?raw=true)
![Alt text](/images/find8.png?raw=true)
![Alt text](/images/find9.png?raw=true)
![Alt text](/images/find10.png?raw=true)
![Alt text](/images/find11.png?raw=true)
![Alt text](/images/find12.png?raw=true)
![Alt text](/images/find13.png?raw=true)

##I also provided to search photos in Flickr's Database (Touch and hold photo to save or share)
![Alt text](/images/find14.png?raw=true)
![Alt text](/images/find15.png?raw=true)

##Concept implementation with iBeacon technology (Concept two iFindArtists App Users pass by each other where one is photographer and other user, the user gets to see a photographer in region)

Issues: the photographer wasnt created but a simple app was made where an iPhone was made as an iBeacon broadcaster to find other iBeacon insight and notify.
![Alt text](/images/find16.png?raw=true)

