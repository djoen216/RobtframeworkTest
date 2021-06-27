*** Settings ***
Library  Selenium2Library
Documentation
...    Login Test Case.


***Variables***
${Browser}  Chrome
${URL}  http://www.google.com
${DESIRED_CAPABILITIES}     browserName: chrome, maxInstances: 5, platform: WIN10
 
*** Test Cases ***
TC_001 Browser Start and Close
    ${options}=    Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
    #Call Method    ${options}    add_argument    headless
    #Call Method    ${options}    add_argument    disable-gpu
    Call Method    ${options}    add_argument      --disable-web-security
    Call Method    ${options}    add_argument      --allow-running-insecure-content
    Call Method    ${options}    add_argument      --user-data-dir\=${CURDIR}/ChromeDevSession
    ${chrome_options}=    Call Method     ${options}    to_capabilities
    Open Browser    ${URL}    chrome    remote_url=http://localhost:4444/wd/hub
    Input Text  xpath=/html/body/div[1]/div[3]/form/div[1]/div[1]/div[1]/div/div[2]/input  abc123
    Sleep    5
    Click Button  name=btnK
    Capture Page Screenshot
    [Teardown]    Close All Browsers
