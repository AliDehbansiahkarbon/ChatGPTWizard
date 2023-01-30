# ChatGPTWizard
<b><h2>This is an OpenAI (ChatGPT) plug-in for Embarcadero RAD Studio IDE.</h2>
<h2>First, you need an API key that you can generate here: (https://beta.openai.com/account/api-keys)<h2>
<br><h2>Remarks</h2>

1. It is compatible with Xe5 and later versions.
1. Uses XSuperObject library which is included in the project files.
1. Consider that if you run it in the IDE without opening any project it will raise a message that it cannot load the SSL library
1. This issue can be fixed if you put SSL libraries(can be find them in resource folder) besides the bds.exe or in Bpl folder(mine is this ==> C:\Users\Public\Documents\Embarcadero\Studio\22.0\Bpl)
or you can use a build event on project's propertises to copy these two class libraries if there is not.
Another point: You don't have to do that because it will work fine when you open any project in the IDE before using this plugin! I'm not sure that this behavior depends on the installed components or libraries or the IDE will load SSL libraries at the moment you open even a new application, although using the plugin when you are working on a project seems more useful anyway.</h3>


<h3><b>How to use</b></h3>

1. you can use the ChatGPT menu from the IDE's main menu directly to ask questions asnd get the answer.
![image](https://user-images.githubusercontent.com/5601608/215458671-a48a4e1d-3b2c-45bd-9da5-603ab82129dc.png)

1. If you need to use the ChatGPT inside the editor you need to make(type) a question directly inside the code editor and sorround it with "cpt:" at the beginning and ":cpt" at the end of question then press Ctrl+Shift+Alt+A or simply select "Ask" from the editor's contex menu by right clicking on the selected text.
  
<br><h2>Simple Test scenario</h2>
Open a new vcl applicatiopn project, add a new unit and remove all the code from it! and type the following line, select all and press Ctrl+Shift+Alt+A.<br>
<b>cpt:Create a full unit in delphi includding a class to create a XML file.:cpt<b>
 ![image](https://user-images.githubusercontent.com/5601608/215461813-7ecf4555-b3a2-4c0e-b85e-6069ead6a3d9.png)


<br>Goud luck.
