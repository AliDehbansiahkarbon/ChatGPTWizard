# ChatGPTWizard

<img src="https://user-images.githubusercontent.com/5601608/225608017-be60c550-0413-49db-b4b6-3664da20e82f.png" width=500 heigth=500 style="margin-left:70px;" />

<br />



<a href="https://www.buymeacoffee.com/adehbanr" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>
<br />
<img src="https://img.shields.io/github/license/AliDehbansiahkarbon/ChatGPTWizard.svg" alt="license">
<img src="https://img.shields.io/github/forks/AliDehbansiahkarbon/ChatGPTWizard.svg" alt="forks">
<img src="https://img.shields.io/github/stars/AliDehbansiahkarbon/ChatGPTWizard.svg" alt="stars">
<img src="https://img.shields.io/github/watchers/AliDehbansiahkarbon/ChatGPTWizard.svg" alt="watchers">
<a href="https://github.com/AliDehbansiahkarbon/ChatGPTWizard/issues"><img src="https://img.shields.io/github/issues-closed/AliDehbansiahkarbon/ChatGPTWizard.svg" alt="issues"></a>
<a href="https://github.com/AliDehbansiahkarbon/ChatGPTWizard/pulls"><img src="https://img.shields.io/github/issues-pr-closed/AliDehbansiahkarbon/ChatGPTWizard.svg" alt="pulls"></a>
<br />
<img src="https://img.shields.io/github/last-commit/AliDehbansiahkarbon/ChatGPTWizard.svg" alt="last-commit">
[![Downloads](https://static.pepy.tech/personalized-badge/video2tfrecord?period=month&units=international_system&left_color=grey&right_color=orange&left_text=Downloads)](https://pepy.tech/project/video2tfrecord)
[![](https://tokei.rs/b1/github/AliDehbansiahkarbon/ChatGPTWizard?category=lines)](https://github.com/AliDehbansiahkarbon/ChatGPTWizard)
[![](https://tokei.rs/b1/github/AliDehbansiahkarbon/ChatGPTWizard?category=code)](https://github.com/AliDehbansiahkarbon/ChatGPTWizard) 
[![](https://tokei.rs/b1/github/AliDehbansiahkarbon/ChatGPTWizard?category=files)](https://github.com/AliDehbansiahkarbon/ChatGPTWizard)

<h2>An AI plug-in for Embarcadero RAD Studio IDE.</h2>

<h3>First Plugin Ever to support Online(ChatGPT, Writesonic, and YouChat) and Offline(Ollama) AI servers!</h3>

#### **PLEASE NOTE THAT You will need an API key (just in Online mode) to use this plugin. see the [API section](#platforms) to Generate an API key**
#### Some API Keys are Limited to a certain usage, after that, you will need to purchase credits to keep using them.


## Key Features:

- Free text question form.
- Dockable question form.
- Inline questions(in the editor).
- Context menu options to help you to find bugs, write tests, optimize code, add comments, etc...
- Class view(Code conversion, code optimizing, test units, and other options per class).
- Predefined Questions for class view.
- History to save your tokens on OpenAI!
- Fuzzy string match searches in the history.
- Animated letters(Like the website).
- AI Code Translator
- Proxy server options. 
- Supports [OpenAI](https://openai.com) ChatGPT as the main AI service.
- Supports [Writesonic](https://writesonic.com/chat) AI as the second AI service.
- Supports [YouChat](https://you.com/code) AI as the third AI service.
- Supports [Ollama(Offline)](https://ollama.com)

<br />

# Disclaimer
As a user of the API key, it is important to understand that you are solely responsible for all content generated through the prompt. Please note that there is no text moderation with this plugin, and your prompt will be sent directly to the AI Server through the API. While mistakes can happen while using browsers, mobile apps, or this plugin, it remains the responsibility of the user to ensure the accuracy and appropriateness of the content generated(prompts).

The plugin serves as a bridge between the user's IDE and the AI Server, enabling faster and smarter development. Please note that the plugin is intended for programming purposes only, and users should use it accordingly. 
For more information, please refer to the Terms of Use defined by OpenAI: [Terms of use](https://openai.com/policies/terms-of-use#:~:text=What%20You%20Cannot,compete%20with%20OpenAI.)

<br />

# 🟢🟢🟢 How to use it in Offline mode 🟢🟢🟢

<details>
<summary>
  🟢 Set up an Offline AI server 👈👈👈
</summary>

In order to use this plug-in with a local host follow these steps:


1- Download and Install Ollama : [here](https://ollama.com)

2- Check if the server is running by opening it in your browser: http://localhost:11434

  You should see something like this screenshot:

  ![Screenshot 2024-04-02 094238](https://github.com/AliDehbansiahkarbon/ChatGPTWizard/assets/5601608/72eb4b84-7971-4354-bcc8-dd8c3818d3ad)
  
  
3- Then you need at least one trained model to be attached to your new AI server, there are a lot of models [here](https://ollama.com/library), so choose one (codellama is a good one, I suggest that for now) and install it with this command in command-line: 
```
ollama run codellama
```
![Screenshot 2024-04-02 094133](https://github.com/AliDehbansiahkarbon/ChatGPTWizard/assets/5601608/d72a4775-c95d-47fa-b3a0-f2ef8ce027b5)

After pulling the model is finished you can ask some questions in CMD right away.

4- Now use this URL instead of the OpenAPI's URL in the setting form of the Plugin in RAD Studio: 
```
http://localhost:11434/api/generate
```

You don't need an Accesskey, no need to change or even clear it, just leave it.

5- Tick the checkbox called Ollama(Offline) and add your model name in the text box in front of the checkbox, in my case, I use "codellama" as the model name.

6- Congratulations! you did it, now enjoy forever free AI assistance.

Note: depending on the hardware resources, the model size, and the parameter count of the model you can experience different speeds and performance, **so do not open any issues about the Offline solution's speed or performance**, there is nothing to do about that with the Plug-in itself, Plug-in is just a bridge between AI server and RAD Studio.

Good luck!

</details>

<br />

## Demo videos

<details>
<summary>
  🟢 Short1(all features)
</summary>
<a href="https://www.youtube.com/watch?v=jHFmmmrk3BU" target="_blank"><img src="https://img.youtube.com/vi/vUgHg3ZPvXI/0.jpg" /></a>
</details>


<details>
  <summary>
  🟢 Short2(ChatGPT, Writesonic, and YouChat actions at the same time)
</summary>
    <a href="https://youtu.be/tEiKmalzZo8" target="_blank"><img src="https://img.youtube.com/vi/vUgHg3ZPvXI/0.jpg" /></a>
</details>

<details>  
<summary>
  🟢 Long
</summary>
<a href="https://www.youtube.com/watch?v=qHqEGfxAhIM" target="_blank"><img src="https://img.youtube.com/vi/qHqEGfxAhIM/0.jpg" /></a>
</details>



<br />

## Platforms

This Plugin Supports the following AI Services:

### [ChatGPT](https://chat.openai.com/chat)

[generate API Key here](https://beta.openai.com/account/api-keys)

### [Writesonic](https://writesonic.com)

[generate API Key here](https://docs.writesonic.com/reference/finding-your-api-key)

### [YouChat](https://you.com/code)

[generate API Key here](https://betterapi.net/about)

**NOTE: ChatGPT is working with Rad Studio 10.1 and above but Other(non-ChatGPT) AI Services are enabled in Rad Studio 10.2 and above!**


## Remarks

- This plugin is free but some AI Services are not free forever.
- It's compatible with Delphi 10.1 Berlin and later versions.
- Uses the XSuperObject library which is included in the project files. you can also find the latest version [here](https://github.com/onryldz/x-superobject/blob/master/XSuperObject.pas)
- Settings are stored in the registry which can be found here: `Computer\HKEY_CURRENT_USER\Software\ChatGPTWizard`

<br />


## How to Install
1- [Getit package manager](https://getitnow.embarcadero.com/chatgptwizard/)

2- [Delphinus package manager](https://github.com/Memnarch/Delphinus/wiki/Installing-Delphinus) - you can install Delphinus package manager and install ChatGPTWizard there. (Delphinus-Support)

3- Direct installation - Open the project in Delphi, right-click on the project node in the project manager, build, and install.


<br />

## How to Use

### **Plug-in's main form**

You can use the ChatGPT menu from the IDE's main menu directly to ask questions and get the answer.
Click on the newly added ChatGPT menu on the IDE(or press Ctrl+Shidt+Alt+C) to open the wizard, type the question, and press the Ask button(or Ctrl+Enter).

<br />

<div style="display:inline">
<img width="350" height="500" src="https://user-images.githubusercontent.com/5601608/220568940-7eba2b94-f091-4400-a031-49b35d1f0d5e.png" alt="how-to-use1"/>
<img width="350" height="500" src="https://user-images.githubusercontent.com/5601608/220568742-8ec94dec-ca44-4331-b245-202d64181fa5.png" alt="how-to-use2"/>
</div>

<br />

**Two New Tabs has been added to get separate results for Writesonic and YouChat.**

So now you can get multiple different answers based on any question, compare, merge, and get the best quality and accuracy for your code.

<br />

![image](./Resources/writesonic-result-tab.jpg)

<br />


### **Settings**

**"Other AI Services"** Tab is responsible for setting up Other AI service's tokens including Writesonic's credentials.

<br />

![image](./Resources/other-ai-services-tab.jpg)

<br />


## Inline Questions

If you need to use the ChatGPT inside the editor you need to type a question directly inside the code editor and surround it with `cpt:` at the beginning and `:cpt` at the end of the question then press `Ctrl+Shift+Alt+A` or simply select "Ask" from the editor's context menu by right-clicking on the selected text.


**Usage Scenario for Inline Questions**

Open a new `vcl` application project, add a new unit, and remove all the code from it! and type the following line, 
select all and press `Ctrl+Shift+Alt+A`.

`cpt:Create a full unit in Delphi including a class to create an XML file.:cpt`


<br />

## Dockable Form

<br />

<div style="display:inline">
<img width="350" height="500" src="https://user-images.githubusercontent.com/24512608/232242537-e2d7737b-4044-4ba9-a76e-c466ade7e6d7.png" alt="dockable-form1"/>
<img width="350" height="500" src="https://user-images.githubusercontent.com/24512608/232242545-5af9612b-27d0-4cf6-b5b2-3d3f187e5fe0.png" alt="dockable-form2"/>
</div>

<br />


Use the **"ChatGPT Dockable"** menu from the main menu to show the dockable form and try to dock the form to the left or right side panel of the IDE, and enjoy with your new Google killer assistant!
<br />



<br />


## Context Menu

Context Menu for Selected text or a block of code. The Result will be inserted after the selected text as a multi-line comment between two brackets `{}`

**Options**

- Ask
- Add Test  - Will try to create a unit test for the selected text.
- Find Bugs - Find fugs in the selected text.
- Optimize - Will Optimize the selected text.
- Add Comments - Will add necessary comments to the selected code.
- Complete code - Will try to add any missing code to the selected code.
- Explain code - will explain what the selected code does in Delphi.

<br />
<br />

![image](https://github.com/AliDehbansiahkarbon/ChatGPTWizard/assets/5601608/51bf3bd9-ab79-4a3c-be18-9e3f7b0cdc06)

<br />

![image_2023-04-25_16-08-40](https://user-images.githubusercontent.com/24512608/236584029-c3982eb3-1824-4146-a611-7c861b034e28.png)


<br />

## Class View

Using the class view you have your class list with some functionalities in a popup menu.
It is also possible to use your custom command based on the selected class in the TreeView, in this case, `@Class` will represent the selected class
in your custom command, if you don't use `@Class` the selected class' source will be attached to the end of your command, just pay attention there will be 
some limitations because at the moment it's not possible to send thousands of lines through the API request.

Please note that it is best to use this feature for small classes. due to API limitations, you cannot send a class with several thousand lines of code in a question.

<br />

![image](https://user-images.githubusercontent.com/5601608/220570745-1720a8eb-026f-42b0-b6d3-c578874a3c9c.png)

<br />

## History

History is available if you enable it in the setting form, it's using SQLite as a simple file-based database.
You can find an empty database in `Resource\DB` that named `"History.sdb"`, copy this file to any place in the disk and address it to the folder in the setting.

<br />

![image](https://user-images.githubusercontent.com/5601608/222926278-9978259a-9ac4-4ba7-bfbb-9675b123756c.png)

<br />

![image](https://user-images.githubusercontent.com/5601608/222926296-3cdaeb05-bfcd-4e5c-8959-e06ee6945c6f.png)

<br />


## Search in History

Right-click on the History grid and check the search item in the search bar that appears, it's not visible by default to save some space, finally, type the keyword
to search and filter, there are two checkboxes as extra options like case sensitive and fuzzy match string search.

<br />

![image](https://user-images.githubusercontent.com/5601608/223150719-40e9169e-e4ea-4bdd-96b5-94830418c9d4.png)

<br />

![image](https://user-images.githubusercontent.com/5601608/223151111-d376cc1f-3688-4eae-82ea-dcf57f877046.png)

<br />

![image](https://user-images.githubusercontent.com/5601608/223151270-0355edbe-80db-43da-a5a0-266e1be8d339.png)

<br />

## Issues with SSL

This issue can be fixed if you put SSL libraries(can find them in the resource folder) alongside the `bds.exe` or in the Bpl folder(mine is `C:\Users\Public\Documents\Embarcadero\Studio\22.0\Bpl`)
or you can use a build event on the project's properties to copy these two class libraries if they don't exist.
Another thing is, You don't have to do that because it will work fine when you open any project in the IDE before using this plugin! I'm not sure that this behavior depends on the installed components or libraries or if the IDE loads SSL libraries at the moment you open even a new application. although using the plugin when you are working on a project seems more useful anyways.

<br />

## Miscellaneous

**Presentation: [ChatGPT wizard.pptx](https://github.com/AliDehbansiahkarbon/ChatGPTWizard/files/10612086/CHAtGPT.wizard.pptx)**

<br />


## Contributors

**Special Thanks to**

- [Ali Sawari](https://github.com/AliSawari)
- [limelect](https://github.com/limelect)


<br />

Do not hesitate to star! if you like it take a leap of faith and hit that 'Star' button, also watch the repository to stay tuned with the latest updates, debugs, features, etc.
All PRs, discussions, and issues are welcome but please read and check the closed issues before opening a new one to avoid duplicates!

**Good luck!**
<hr>
<p align="center">
<img src="https://i0.wp.com/blogs.embarcadero.com/wp-content/uploads/2022/11/dlogonew-5582740.png?resize=254%2C242&ssl=1" alt="Delphi">
</p>
<h5 align="center">
Made with :heart: on Delphi
</h5>
