# Used resources
# https://www.toolsqa.com/selenium-webdriver/wait-commands/
# https://www.alkanesolutions.co.uk/blog/2018/12/06/powershell-selenium-and-browser-automation/
# https://stackoverflow.com/questions/37582981/how-do-you-create-a-timespan-from-milliseconds-in-powershell
# https://seleniumhq.github.io/selenium/docs/api/dotnet/

Add-Type -Path "C:\Temp\SeleniumV2\net45\*.dll"
$DebugPreference = "Continue"

get-process chromedriver | stop-process -ErrorAction SilentlyContinue -Force | out-null

$seleniumOptions = New-Object OpenQA.Selenium.Chrome.ChromeOptions # Create new Object of the class ChromeOptions. ChromeOptions in it's turn is a Class of the namespace OpenQA.Selenium.Chrome
$seleniumOptions.AddAdditionalCapability("useAutomationExtension", $false) # Use the method AddAdditionalCapability of the newly created object based on the ChromeOptions Class

seleniumDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($seleniumOptions) # Create a new object of the ChromeDriver class and feed it the options by the object of the ChromeOptions Class. ChromeDriver is a class of the namespace OpenQA.Selenium.Chrome
$seleniumDriver.Navigate().GoToURL("https://www.hln.be")  
    # Navigate is a Method of the CLass ChromeDriver
    # GoToURL is Method of the Method navigate()

cleaner # Clears up console in VS-code the real way

Write-debug  "BEGIN: $(get-date)" # Record start-time

                    ############## Concept ##############

# A namespace is a collection of types that share a common theme or act against a common service
    # OpenQA.Selenium.Support.UI                                            = Namespace

# This means that a class lives within a namespace. (All .NET classes live in namespaces)
    # OpenQA.Selenium.Support.UI.ExpectedConditions                         = Class ->  To access with a namespace followed by a dot (.)

# So now we can access the static method within that class
    # [OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementIsVisible     = Method of the Class ExpectedConditions accessed by ::

# So the hierarchy is Namespace > Class > Method\Function - Static Method

# Make the driver wait 10 seconds
# This gets triggered by the until(), without it; it won't wait for 10 seconds and will move on to the next line.
# If the element is visible after just one second, it will continue on, if not it will keep looking for the remaining 8 seconds after which it will continue on to the next line.
$seleniumWait = New-Object -TypeName OpenQA.Selenium.Support.UI.WebDriverWait($seleniumDriver, (New-TimeSpan -Seconds 9)) 
$seleniumWait.Until([OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementIsVisible([OpenQA.Selenium.By]::XPath("/html/body/div[1]/main/div/section[1]/form/buttn")))

$test = New-Object -TypeName OpenQA.Selenium.Chrome.ChromeDriver # New object of Chromedriver class
$test.GetScreenshot() # Use the Method

[OpenQA.Selenium.Chrome.Chrome]::DriverGetScreenshot

Write-debug "END: $(get-date)" # Record end-time

#region Debug
$seleniumWait.Message = "Time is up, lets get it."
write-host $seleniumWait.Message -ForegroundColor Cyan
$seleniumWait # Debug
#endregion

# Click to go to the website so we can do some scraping
$seleniumDriver.FindElementByXpath("/html/body/div[1]/main/div/section[1]/form/button").Click()

#  We shall scrape the temperature displayed on the homepage
$seleniumDriver.FindElementByClassName("weather-teaser__temperature").Text
$seleniumDriver.Quit()	
