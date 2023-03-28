# ChatGPTWizard

<img src="https://user-images.githubusercontent.com/5601608/225608017-be60c550-0413-49db-b4b6-3664da20e82f.png" width=500 heigth=500 style="margin-left:70px;" />

<br />
<br />

<h2>An OpenAI plug-in for Embarcadero RAD Studio IDE.</h2>

<h3>First Plugin Ever to support ChatGPT & Writesonic!</h3>
<br /

#### **NOTE: You will need an API key to use this plugin. see the [API section](#platforms)**

<br />

## Demo

Short1(ChatGPT)

<a href="https://www.youtube.com/watch?v=vUgHg3ZPvXI" target="_blank"><img src="https://img.youtube.com/vi/vUgHg3ZPvXI/0.jpg" /></a>

Short2(Writesonic)

<a href="https://www.youtube.com/watch?v=Uq9WfE7iVjA" target="_blank"><img src="https://img.youtube.com/vi/vUgHg3ZPvXI/0.jpg" /></a>


Long

<a href="https://www.youtube.com/watch?v=qHqEGfxAhIM" target="_blank"><img src="https://img.youtube.com/vi/qHqEGfxAhIM/0.jpg" /></a>

<br />

## Platforms

This Plugin Supports the following AI Services:

### [ChatGPT](https://chat.openai.com/chat)

[generate API Key here](https://beta.openai.com/account/api-keys)

### [Writesonic](https://writesonic.com)

[generate API Key here](https://docs.writesonic.com/reference/finding-your-api-key)

**NOTE: Other AI Services(non-ChatGPT) are enabled in Rad Studio 10.2 and above!**


## Remarks

- It's compatible with Xe5 and later versions.
- Uses XSuperObject library which is included in the project files. you can also find the latest version [here](https://github.com/onryldz/x-superobject/blob/master/XSuperObject.pas)
- Settings are stored in registry which can be found here: `Computer\HKEY_CURRENT_USER\Software\ChatGPTWizard`
- Consider that if you run it in the IDE without opening any project it will raise a message that it cannot load the SSL library. for more details see [here](#issues-with-ssl)

<br />


## How to Install

Open the project, right-click on the project in the project manager, build, and install.

<br />

## How to Use

### **Plug-in's main form**

You can use the ChatGPT menu from the IDE's main menu directly to ask questions and get the answer.
Click on the newly added ChatGPT menu on the IDE(or press Ctrl+Shidt+Alt+C) to open the wizard, type the question and press the Ask button(or Ctrl+Enter).

<br />

![image](https://user-images.githubusercontent.com/5601608/220568940-7eba2b94-f091-4400-a031-49b35d1f0d5e.png)
![image](https://user-images.githubusercontent.com/5601608/220568742-8ec94dec-ca44-4331-b245-202d64181fa5.png)

<br />

**A New Tab has been added to get a separate result for Writesonic.**

So now you are able to get two different answers based on any question, compare, merge and get the best quality with codes.

<br />

![image](./Resources/writesonic-result-tab.jpg)

<br />


### **Settings**

**"Other AI Services"** Tab is responsible for setting up Other AI service's tokens including Writesonic's credentials.

<br />

![image](./Resources/other-ai-services-tab.jpg)

<br />


## Inline Questions

If you need to use the ChatGPT inside the editor you need to type a question directly inside the code editor and surround it with "cpt:" at the beginning and ":cpt" at the end of the question then press Ctrl+Shift+Alt+A or simply select "Ask" from the editor's context menu by right-clicking on the selected text.

<br />

## Dockable Form

Use the "ChatGPT Dockable" menu from the main menu to show the dockable form and try to dock the form to the left or right side panel of the IDE, and enjoy with your new Google killer assistant!
<br />

![image](https://user-images.githubusercontent.com/5601608/220598235-a1dbd0bd-400c-4284-9017-a3ff50cb0d4c.png)
![image](https://user-images.githubusercontent.com/5601608/220598309-1aef8789-5670-487a-b5f7-817fa7a099ef.png)

<br />

## Class View

Using the class view you have your class list with some functionalitis in a popup menu.
It is also possible to use your custom command based on the selected class in the TreeView, in this case @Class will represent the selected class
in your custom command, if you don's use @Class the selected class' source will be attached to the end of your command, just pay attention there will be 
some limitations, because at the moment it's not possible to send thousand of lines through the API request.

Please mind that it is best to use this feature for small classes. due to API limitation you cannot send a class with several thousand lines of code in a question.

<br />

![image](https://user-images.githubusercontent.com/5601608/220570745-1720a8eb-026f-42b0-b6d3-c578874a3c9c.png)

<br />

## History

History is available if you enable it in the setting form, it's using SQLite as a simple file base database.
You can find an empty database in Resource\DB that named "History.sdb", copy this file to any place in the disk and address to the folder in the setting.

<br />

![image](https://user-images.githubusercontent.com/5601608/222926278-9978259a-9ac4-4ba7-bfbb-9675b123756c.png)

<br />

![image](https://user-images.githubusercontent.com/5601608/222926296-3cdaeb05-bfcd-4e5c-8959-e06ee6945c6f.png)

<br />


## Search in History

Right click on the History grid and check search item to the search bar appears, it's not visibile by default to save some space, finally type the keyword
to search and filter, there are two checkboxes as extra options like case sensitive and fuzy match string search.

<br />

![image](https://user-images.githubusercontent.com/5601608/223150719-40e9169e-e4ea-4bdd-96b5-94830418c9d4.png)

<br />

![image](https://user-images.githubusercontent.com/5601608/223151111-d376cc1f-3688-4eae-82ea-dcf57f877046.png)

<br />

![image](https://user-images.githubusercontent.com/5601608/223151270-0355edbe-80db-43da-a5a0-266e1be8d339.png)

<br />

## Issues with SSL

This issue can be fixed if you put SSL libraries(can find them in the resource folder) alongside the `bds.exe` or in Bpl folder(mine is `C:\Users\Public\Documents\Embarcadero\Studio\22.0\Bpl`)
or you can use a build event on the project's properties to copy these two class libraries if they don't exist.
Another thing is, You don't have to do that because it will work fine when you open any project in the IDE before using this plugin! I'm not sure that this behavior depends on the installed components or libraries or if the IDE loads SSL libraries at the moment you open even a new application. although using the plugin when you are working on a project seems more useful anyways.

<br />

## Usage Scenario

Open a new `vcl` applicatiopn project, add a new unit and remove all the code from it! and type the following line, 
select all and press `Ctrl+Shift+Alt+A`.

`cpt:Create a full unit in Delphi including a class to create an XML file.:cpt`

<br />

![image](https://user-images.githubusercontent.com/5601608/215461813-7ecf4555-b3a2-4c0e-b85e-6069ead6a3d9.png)

<br />



**Presentation: [ChatGPT wizard.pptx](https://github.com/AliDehbansiahkarbon/ChatGPTWizard/files/10612086/CHAtGPT.wizard.pptx)**


**Good luck!**
