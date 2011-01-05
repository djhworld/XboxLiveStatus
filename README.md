This was a project I undertook to learn Objective-C, the code is very messy and not very good. 

## What on earth is this?
The goal of the application was to satisfy my inherent laziness combined with my joy for online gaming. There's nothing worse than having to keep turning your Xbox on to find out what your XBL friends are up to and I loathe the official MS website because of Silverlight (it makes me laptop heat up and cry a little). 

So, to appease my frustrations I developed this application. It might be a little overengineered and frankly, a waste of your time, but it was useful for me.

## Notice
The only downside of this application is the fact that Microsoft have sealed off their gamertag API to game developers only, so I've had to make do with a proxy that Duncan Mackenzie has put up. While I appreciate Duncan's efforts (very much so), I think he uses some degree of caching in his API to avoid too many calls to the Microsoft servers, so the statuses of your friends might be 15 minutes out of date. It's a small price to pay though.

Oh and you have to manually enter the gamertags you wish to follow when you first start up the application (it saves this though?)

## Adding gamertags? Why? I have loads of XBL friends

Yeah, like I said, Microsoft sealed off their gamertag API. What would have been nice is a simple REST service to retrieve a list of your XBL friends via a given gamertag but alas, MS don't seem to keen on any data being made public.

## What do I do with this?
This is the codebase for the work, just checkout the lot and open the project in Xcode to build it.

If you can't be bothered to do that then you're more than welcome to download the application from my website <http://www.djharper.co.uk/portfolio.php>

## Obligatory screenshot

That's right, the only XBL friend I have is myself.

![Alt text](http://www.djharper.co.uk/portfolio/images/xboxlivestatus3.png)
