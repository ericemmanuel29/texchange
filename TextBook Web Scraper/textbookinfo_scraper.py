import time
import bs4 as bs
import urllib.request
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.common.exceptions import NoSuchElementException

sauce = urllib.request.urlopen('https://sis.rpi.edu/reg/zs201701.htm').read()  #go to sis website with all courses
soup = bs.BeautifulSoup(sauce, 'lxml') #create bs object

text_file = open("TextBookInfo.txt", "w") #open a text file

links = list()

for url in soup.find_all('a'):   #go through all links on webpage
    url_string = str(url.get('href')) #convert to string
    if (url_string != 'None' and url_string not in links): #no duplicates or null values
        links.append(url_string) 

courses_remaining = len(links) - 1
for link in links:
    driver = webdriver.Chrome()
    driver.get(link)
    time.sleep(1)
    classInfo = driver.find_element_by_class_name("efCourseHeader")
    classInfo_string = str(classInfo.text)
    classInfo_string = classInfo_string[20:]
    #print(classInfo_string)
    print("***", courses_remaining, " courses left to search ***")
    courses_remaining -= 1
    text_file.write(classInfo_string + " ")
    time.sleep(1)
    if len(driver.find_elements_by_id("efCourseErrorSection")) > 0 :
        text_file.write('NO TEXTBOOK FOR THIS COURSE' + '\n') 
        #print("NO TEXTBOOK FOR THIS COURSE")
        driver.quit()
    else:
        textbookInfoLink = driver.find_element_by_link_text('Check Availability')
        textbookInfoLink.click()
        time.sleep(1)
        textbookInfo = driver.find_elements_by_class_name("material-group-title")
        for textbook in textbookInfo:
            #print(textbook.text)
            text_file.write(textbook.text + '\n')
        driver.switch_to_window(driver.window_handles[-1])
        driver.quit()

        #text_file.write(textbookInfo_string + '\n')
        #for element in driver.find_elements_by_tag_name('span'):
            #if (str(element.get_attribute("id")) == "materialTitleImage"):
            
text_file.close()