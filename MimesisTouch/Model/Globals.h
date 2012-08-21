/*! \mainpage Welcome to GeNIE
 
 <b>GeNIE</b> stands for <b>Gestural Narrative Interaction Engine.</b> The goal of the project is to create a standardized interactive narrative engine that can be driven by gesture-based controls, in an attempt to provoke experimentation around the possibilities such controls afford for storytelling.
 
 To use GeNIE successfully, you will need to be familiar with Objective-C and programming for iOS in general. While it's possible to take other approaches, GeNIE has been developed in close proximity to the <a href="http://www.cocos2d-iphone.org/">Cocos2D</a> animation library, and as a result you'll have an easier time of it if you do the same. Cocos2D version 1.0.1 is included in the core GeNIE distribution.
 
 When developing a project using GeNIE, you have two main tasks:
 
 - Creating the narrative
 - Creating the views
 
 Narrative in GeNIE is driven by a narrative script, which is written in XML. See \ref script for details on its formatting.
 
 Views in GeNIE provide visual and audio representations of the items in the narrative script, and are how those items are made interactive. See \ref views for details on how views can be built. GeNIE currently supports landscape orientation only.
 
 Note that at present GeNIE is primarily a narrative engine which provides a framework for creating a gesture-driven story. Right now GeNIE does not itself assist with gesture recognition, nor does it provide any special functions for linking gestures to narrative events. The demo project and the \ref aboutDemo section, however, contain examples and explanations of both which should prove instructive.
 
 More about GeNIE:
 - \subpage script
 - \subpage schema
 - \subpage scriptElements
 - \subpage views
 - \subpage aboutDemo
 - \subpage customCommands
 - \subpage credits
 
 <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/3.0/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-nd/3.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/3.0/">Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License</a>.
 
 */

//-----------------------------------------------------------

/*! \page credits Credits
 
 D. Fox Harrell, Principal Investigator
 
 Erik Loyer, Lead Developer
 
 Kenny Chow, Additional Research, Design and Development
 
 Thanks to the National Endowment for the Humanities for its support of this project.
 
 */

//-----------------------------------------------------------

/*! \page script Writing the Narrative Script
 
 The GeNIE engine is driven by a narrative script, which is an XML file built according to some specific rules.
 
 The narrative script does not define interactivity in any form; that task is left to the views you will create to represent the items defined in the script. Instead, the narrative script defines the basic structures of setting, shot, object, concept, character and event. Those structures are instantiated by the engine and can then be triggered or modified in real time by interactions defined in the views.
 
 Note that identifiers, for those elements which require them, must be unique across the entire script.
 
 The script is parsed by the NarrativeModel using its <code>parseNarrativeScript:</code> method, which accepts the name of your narrative script file (minus the .xml extension) as its sole parameter. In the demo project, this call is issued from the GeNIEAppDelegate class.
 
 The textual schema below shows the recommended structure and ordering of elements in a narrative script. A visual schema is also available: \ref schema
 
 <code>
 \ref narrative<br>
 &nbsp;&nbsp;\ref initialSetting<br>
 &nbsp;&nbsp;\ref setting<br>
 &nbsp;&nbsp;&nbsp;&nbsp;\ref initialShot<br>
 &nbsp;&nbsp;&nbsp;&nbsp;\ref shot<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[\ref adjacentShot]<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...<br>
 &nbsp;&nbsp;&nbsp;&nbsp;</shot><br>
 &nbsp;&nbsp;&nbsp;&nbsp;...<br>
 &nbsp;&nbsp;&nbsp;&nbsp;\ref eventStructure<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\ref eventClause<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...<br>
 &nbsp;&nbsp;&nbsp;&nbsp;</eventStructure><br>
 &nbsp;&nbsp;&nbsp;&nbsp;[\ref topic]<br>
 &nbsp;&nbsp;&nbsp;&nbsp;...<br>
 &nbsp;&nbsp;&nbsp;&nbsp;[\ref prop]<br>
 &nbsp;&nbsp;&nbsp;&nbsp;...<br>
 &nbsp;&nbsp;&nbsp;&nbsp;[\ref actor<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[\ref sentiment<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\ref emotion<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[\ref demonstration<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\ref event<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\ref eventAtom<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</event><br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</demonstration>]<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</emotion><br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</sentiment>]<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...<br>
 &nbsp;&nbsp;&nbsp;&nbsp;</actor>]<br>
 &nbsp;&nbsp;&nbsp;&nbsp;...<br>
 &nbsp;&nbsp;&nbsp;&nbsp;\ref eventGroup<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\ref initialEvent<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\ref event<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[\ref startConditions<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\ref condition<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</startConditions>]<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\ref eventAtom<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</event><br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\ref endConditions<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\ref condition<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</endConditions><br>
 &nbsp;&nbsp;&nbsp;&nbsp;</eventGroup><br>
 &nbsp;&nbsp;&nbsp;&nbsp;...<br>
 &nbsp;&nbsp;</setting><br>
 &nbsp;&nbsp;...<br>
 </narrative>
 </code>
 
 */
 
//-----------------------------------------------------------

 /*! \page scriptElements Index of Narrative Script Elements
 
 - \subpage actor
 - \subpage adjacentShot
 - \subpage condition
 - \subpage demonstration
 - \subpage emotion
 - \subpage endConditions
 - \subpage event
 - \subpage eventAtom
 - \subpage eventClause
 - \subpage eventGroup
 - \subpage eventStructure
 - \subpage initialEvent
 - \subpage initialSetting
 - \subpage initialShot
 - \subpage narrative
 - \subpage prop
 - \subpage sentiment
 - \subpage setting
 - \subpage shot
 - \subpage startConditions
 - \subpage topic
 
 */

//-----------------------------------------------------------

 /*! \page narrative <narrative>
 
 Every GeNIE script starts with one of these.
 
 */
 
//-----------------------------------------------------------

 /*! \page initialSetting <initialSetting settingRef="">
 Settings are the coarsest unit of narrative structure. This element defines which setting goes first.
 
 <h3>settingRef</h3>
 The id of the setting which goes first.
  
*/
 
//-----------------------------------------------------------

 /*! \page setting <setting id="">
 A setting is the coarsest unit of narrative structure. A narrative can theoretically have one or more settings, however GeNIE currently contains no facility for changing settings. As a result you should put your entire narrative inside a single setting for now.
 
 <h3>id</h3>
 The setting's unique id.
  
*/
 
//-----------------------------------------------------------

 /*! \page initialShot <initialShot shotRef="">
 Shots are views of a setting. This element defines which shot is shown first.
 
 <h3>shotRef</h3>
 The id of the shot to be shown first.
 
 */

 //-----------------------------------------------------------

 /*! \page shot <shot id="" [muted=""] [internal=""]>
 A setting can have one or more shots (think wide shot, medium shot, close-up, but also things like thought space, flashback, etc.).
 
 <h3>id</h3>
 The shot's unique id.
 
 <h3>muted</h3>
 Boolean. When the system asks for a random shot to cut to, is this shot barred from being included?
 
 <h3>internal</h3>
 Boolean. Does this shot represent an internal mental state? (Note: if it does, then while the shot is active, changes to the mood of an actor who is thinking about a topic will affect only their internal, private emotions about that topic, as opposed to their publicly-expressed emotions.)
  
 */

 //-----------------------------------------------------------

 /*! \page adjacentShot <adjacentShot direction="" shotRef="">
 Adjacent shots determine what shots the engine can cut to while a given shot is active. They are optional, and you can have as many as you want.
 
 <h3>direction</h3>
 This property lets you apply a name to the kind of action that should trigger a cut to this shot. This comes in handy if you want a single action, say "zoomIn," to be meaningful across multiple shots—cutting from a wide shot to a medium shot, and from a medium shot to a close-up, for example. Hooking up the action to a specific gesture is up to you (see \ref shotView for details), but the Shot class has an <code>adjacentShotForKey:</code> method that will return the adjacent shot given a string that matches its <code>direction</code> property.
 
 <h3>shotRef</h3>
 The id of the shot to be made adjacent.
  
 */

 //-----------------------------------------------------------

 /*! \page eventStructure <eventStructure>
 Each narrative has one of these, which defines the sequencing of event groups in the narrative. Used for high-level narrative shaping within a setting.
  
 */

 //-----------------------------------------------------------

 /*! \page eventClause <eventClause type="" minCount="" maxCount="" [subClause=""] [exitTo=""]>
 There can be one or more of these. Any event group whose <code>type</code> property matches the event clause's <code>type</code> property can be played during that clause (currently they are randomly selected).
 
 <h3>type</h3>
 Any event groups whose types match the value of this property can be played during this clause.
 
 <h3>minCount</h3>
 Integer. Minimum number of times this event clause can be played.
 
 <h3>maxCount</h3>
 Integer. Maximum number of times the event clause can be played.
 
 <h3>subClause</h3>
 The id of an event clause to nest inside this one.
 
 <h3>exitTo</h3>
 The id of the event clause to be played after this one.
  
 */

 //-----------------------------------------------------------

 /*! \page topic <topic id="" description="">
 Defines something an actor can think about in the narrative.
 
 <h3>id</h3>
 The topic's unique id.
 
 <h3>description</h3>
 How the topic will be described for the player.
  
 */

 //-----------------------------------------------------------

 /*! \page prop <prop id="" [topicRef=""]>
 Defines an inanimate object in the narrative.
 
 <h3>id</h3>
 The prop's unique id.
 
 <h3>topicRef</h3>
 The id of the topic this prop represents (optional).
  
 */

 //-----------------------------------------------------------

 /*! \page actor <actor id="" name="" subjectivePronoun="" objectivePronoun="">
 Defines a character in the narrative.
 
 <h3>id</h3>
 The actor's unique identifier.
 
 <h3>name</h3>
 The name of the actor as it will be displayed.
 
 <h3>subjectivePronoun</h3>
 The subjective pronoun (i.e. "he, she") associated with the actor, used to help the system make grammatically correct references.
 
 <h3>objectivePronoun</h3>
 The objective pronoun (i.e. "his, her") associated with the actor, used to help the system make grammatically correct references.
  
 */

 //-----------------------------------------------------------

 /*! \page sentiment <sentiment topicRef="" transparency="">
 Each sentiment bundles together all the conflicting emotions an actor may feel about a topic.
 
 <h3>topicRef</h3>
 The id of the topic that the sentiment is about.
 
 <h3>transparency</h3>
 Float (0.0 - 1.0). How likely is it that the actor, when prompted, will express their "true" (i.e. internal) emotions about the topic, as opposed to their external emotions?
  
 */

 //-----------------------------------------------------------

 /*! \page emotion <emotion name="" internalStrength="" externalStrength="" description="">
 Defines a single emotion an actor feels about a topic, and how strong it is for them both internally and externally.
 
 <h3>name</h3>
 The name of the emotion (internal use only, like an id, but doesn't need to be unique).
 
 <h3>internalStrength</h3>
 Positive integer. How strongly does the actor feel this emotion "inside"? Used to calculate the probability that a given emotion will be expressed.
 
 <h3>externalStrength</h3>
 Positive integer. How strongly does the actor project this emotion externally? Used to calculate the probability that a given emotion will be expressed.
 
 <h3>description</h3>
 A description of the emotion, usually in the form of a noun-preposition construct such as "dislike for," which gets used in describing the emotion to the player.
  
 */

 //-----------------------------------------------------------

 /*! \page demonstration <demonstration [operator=""] [value=""]>
 Demonstrations are groups of events that get played when an actor is prompted to express (or "demonstrate") a particular emotion. If a demonstration contains multiple events, then one is picked randomly to execute when the demonstration is played. Demonstration elements are evaluated in the order in which they are declared, as if chained in a series of else-if statements.
 
 <h3>operator</h3>
 Legal values: <, <=, ==, >=, and >. Used with the <code>value</code> property to determine if this demonstration is eligible to be played given the emotion's current strength.
 
 <h3>value</h3>
 Positive integer. Used with the <code>operator</code> property to determine if this demonstration is eligible to be played given the emotion's current strength.
  
 */

 //-----------------------------------------------------------

 /*! \page eventGroup <eventGroup id="" type="">
 Event groups are the core of the narrative, defining the specifics of what can happen in a given setting.
 
 <h3>id</h3>
 The event group's unique id.
 
 <h3>type</h3>
 Matches the event group with the event clauses during which it can be played.
  
 */

 //-----------------------------------------------------------

 /*! \page initialEvent <initialEvent eventRef="">
 Each <code><eventGroup></code> element can have one and only one <code><initialEvent></code> which identifies the event that will be played when the event group starts up.
 
 <h3>eventRef</h3>
 The identifier of the event which is to be played when the event group starts up.
  
 */

 //-----------------------------------------------------------

 /*! \page event <event id="" [maxCount=""] [weight=""] [random=""]>
 Each <code><eventGroup></code> element can have one or more <code><event></code> elements that define the specifics of what can occur in that event group. 
  
 In addition, each <code><demonstration></code> element can have one or more <code><event></code> elements that define the specifics of how that demonstration may be enacted.

 <h3>id</h3>
 A unique identifier for the event.
 
 <h3>maxCount</h3>
 The maximum number of times this event can be played. If unspecified, defaults to a very high number.
 
 <h3>weight</h3>
 A positive integer that determines the likelihood that this event will be played relative to other eligible events. A value of zero means the event will never be played unless specifically triggered by an event atom. If unspecified, defaults to 1.
 
 <h3>random</h3>
 A boolean value that determines whether this event, when played, will execute a single randomly chosen event atom (true), or all of the event's event atoms in sequence (false). If unspecified, defaults to false.
  
 */

 //-----------------------------------------------------------

 /*! \page startConditions <startConditions [operator=""]>
 Each <code><event></code> element can optionally have a single <code><startConditions></code> element that defines the conditions that must be in effect for the event to be triggered.
 
 <h3>operator</h3>
 If multiple start conditions are specified, determines whether they will be evaluated with a logical AND or OR between them. If unspecified, defaults to AND.
  
 */

 //-----------------------------------------------------------

 /*! \page condition <condition itemRef="" property="" operator="" value="">
 Each <code><startConditions></code> and <code><endConditions></code> element can have one or more <code><condition></code> elements that define a set of starting or ending conditions.
 
 <h3>itemRef</h3>
 The identifier of an item (of any type), a property of which is to be tested as part of the condition.
 
 <h3>property</h3>
 Name of the item's property, the value of which is to be tested as part of the condition.
 
 <h3>operator</h3>
 Determines which operator will be used in comparing the current value of the item's property with that specified in the condition's value property. Legal values are <, <=, ==, >=, and >.
 
 <h3>value</h3>
 The value that the condition is testing for.
 
 Currently supported combinations of items and properties:
 
 Event
 <ul>
 <li><b>isCompleted</b> - Returns true if the event has been played at least once.
 </ul>
  
 */

 //-----------------------------------------------------------

 /*! \page eventAtom <eventAtom itemRef="" command="" [content=""] [topic=""]>
 Each <code><event></code> element can have one or more <code><eventAtom></code> elements that define specific actions to be taken when the event is played.
 
 <h3>itemRef</h3>
 The identifier of an item (of any type) that will be directed to execute the command specified in the event atom.
 
 <h3>command</h3>
 The command to be executed by the item referenced in the event atom. Note that you can specify custom commands and handle them in your views by making each view an observer of the NarrativeModel and then implementing the <code>executeEventAtom:</code> method—this method is called on all NarrativeModel observers whenever an event atom is run.
  
 In addition to the built-in commands listed below, it is possible to define custom commands and handle them in your views: see \ref customCommands.
 
 These are the built-in commands for each item type: 
 
 Actor
 <ul>
 <li><b>enter</b> - The actor enters the stage.</li>
 <li><b>exit</b> - The actor exits the stage.</li>
 <li><b>expressSentiment</b> - The actor expresses their current feelings about the topic specified in the content property. The current transparency of the actor's sentiment about the topic determines whether the emotion expressed will be their internal or external feelings about the topic.</li>
 <li><b>lookAt</b> - The actor looks at the actor specified in the content property (description of the action will be displayed in the NarratorView).</li>
 <li><b>lookAwayFrom</b> - The actor looks away from the actor specified in the content property (description will be displayed in the NarratorView).</li>
 <li><b>modifyEmotion</b> - Changes the strength of an actor's emotion by the specified amount. The topic, emotion, internal/external disposition, and amount to change are specified in the content property in the format [topicRef]:[emotionName]:[internal/external]:[strengthChange]. For example: 'hatTopic:dislike:internal:-2'.</li>
 <li><b>say</b> - The actor "speaks" the dialogue specified in the content property (will be displayed in the NarratorView).</li>
 <li><b>setEmotion</b> - Sets the strength of an actor's emotion to a specific value. The topic, emotion, internal/external disposition, and strength are specified in the content property in the format [topicRef]:[emotionName]:[internal/external]:[strength]. For example: 'hatTopic:dislike:internal:10'.</li>
 <li><b>setMood</b> - Sets the actor's current mood to the string specified in the content property. If the actor's currentTopic property is not nil, and the mood matches the name of an emotion associated with that topic, then either the internal or the external component of the emotion will be incremented, depending on the value of the current shot's 'internal' property.</li>
 <li><b>setTransparency</b> - Sets the transparency of the actor's sentiment on a topic to a specific value. Both the topic and the value are specified in the content property in the format [topicRef]:[value]. For example: 'hatTopic:0.7'.</li>
 <li><b>storeTransparency</b> - Saves the current transparency of the actor's sentiment specified on the content property for later retrieval.</li>
 <li><b>think</b> - The actor "thinks" the thought specified in the content property (will be displayed in the NarratorView).</li>
 </ul>
 
 Setting
 <ul>
 <li><b>setCurrentShot</b> - Sets the setting's current shot to the shot that matches the identifier in the content property.</li>
 </ul>
 
 System
 <ul>
 <li><b>playEvent</b> - Plays the event with the identifier specified in the content property.</li>
 <li><b>wait</b> - Instructs the system to do nothing for the number of seconds specified in the content property.</li>
 </ul>
 
 */

//-----------------------------------------------------------

/*! \page endConditions <endConditions [operator=""]>
 Each <code><eventGroup></code> element can optionally have a single <code><endConditions></code> element that defines the conditions that must be in effect for the event group to end.
 
 <h3>operator</h3>
 If multiple end conditions are specified, determines whether they will be evaluated with a logical AND or OR between them. If unspecified, defaults to AND.
 
 */

//-----------------------------------------------------------

/*! \page schema Narrative Script Visual Schema
 
 This diagram provides a graphical overview of the structure of the narrative script. A textual overview of the script can be found here: \ref script
 
 \image html genie_narrativeschema.png

 */

//-----------------------------------------------------------

/*! \page views Creating Views
 
 Views define the visual and audio representation of a GeNIE narrative. They are also where interactivity is handled.
 
 GeNIE contains several Cocos2d-based abstract view classes to help get you started in creating the views for your narrative. To build your project, you will generally create  one or more extensions of those classes for each item defined in your narrative script.
 
 For instance, if you have defined a "hat" prop in your narrative, you'll likely want to create a Hat class which extends GeNIE's PropView class. This new class will handle the display of a sprite for the hat, as well as any animations or behaviors it might possess.
 
 Sometimes you might want to create more than one view class to represent the same narrative model object. For example, the actor "Sarah" might appear in multiple shots in your story: a wide shot, medium shot, and close-up. The mechanics for driving each of those representations might be quite different: in the wide shot she might be able to walk around, while in the close-up there might be much more detail in her facial expressions. By creating separate view classes for Sarah in each shot, you can keep these different representations self-contained.
 
 Views are also where gesture handling takes place. By handling touch and accelerometer events, a view translates those events into calls which modify model objects.
 
 The typical pattern is for the ShotView to manage the views which it contains—instantiating them, handling interactivity within the shot and passing it off to individual view handlers if needed, and triggering the display of new shots.
 
 For more detail, see \ref aboutDemo.
 
 You may wish to define custom EventAtom commands in your narrative script. For details on how to respond to those commands, see \ref customCommands.
 
 */

 //-----------------------------------------------------------
 
 /*! \page aboutDemo How the Demo Project's Views Work
 
 This in-depth explanation of how the views in the GeNIE demo project work should give you some guidance for how to construct your own projects.
 
 As GeNIE is based on the Cocos2D engine, you should also be familiar with the <a href="http://www.cocos2d-iphone.org/wiki/doku.php/prog_guide:index">Cocos2D Programming Guide.</a>
 
 - \subpage narrativeView
 - \subpage narratorView
 - \subpage shotView
 - \subpage actorView
 - \subpage propView
 - \subpage topicView
 
 */

 //-----------------------------------------------------------

 /*! \page narrativeView Extending the NarrativeView Class
 
 The NarrativeView class is the base view class in GeNIE. It is an abstract class that must be extended so that it can manage your custom NarratorView and ShotView objects (also abstract classes that must be extended to be useful). In the demo project this class is extended as TiltNarrativeView.
 
 In the <code>initWithController:</code> method of TiltNarrativeView, note that the default NarratorView has been replaced with IconNarratorView. This extension of the abstract NarratorView class knows which custom icons to display for each of the actors in the story. Note that accelerometer setup has also been added (more on this below).
 
 The <code>setCurrentShot:</code> method includes the most extensive modifications, as it has to handle transitions from one shot to another. Each shot model is paired with its appropriate ShotView class, and the current shot is retired in each case. Note the special handling of "closeUpShot" and "thoughtSpaceShot"—because we want a smooth transition between these two shots instead of a cut, both shots are actually handled by the same class.
  
 You are, of course, free to handle your shot views however you like.
  
 Finally, an <code>accelerometer:didAccelerate:</code> method is added to handle acceleration events. In this case, subsequent tilts left and right are used to trigger a cut to a random adjacent shot.
  
 */

 //-----------------------------------------------------------

 /*! \page narratorView Extending the NarratorView Class
  
 The NarratorView class manages the display of the bar that slides up from the bottom of the screen to display textual narrative content associated with the icon of the actor it is coming from. It is an abstract class that must be extended so that it can know which icons to associated with which actors in your narrative script. If you want the view to respond in specific ways to custom EventAtom commands this would be the place to set that behavior up as well. In the demo project this class is extended as IconNarratorView.
  
 In the <code>iconForActor:</code> method of IconNarratorView, note that specific icon image files are matched up to specific actors and then returned. Each icon is 52x52 (non-Retina display dimensions). 
  
 */

 //-----------------------------------------------------------

 /*! \page shotView Extending the ShotView Class
  
 The ShotView class is responsible for rendering a given shot, and as such is the workhorse of all of GeNIE's view classes. It is an abstract class that must be extended so that you can present distinct media and behavior for each shot in your narrative. The ShotView typically manages all of the PropView, TopicView, and ActorView instances that are relevant to the shot, and handles interactivity for the shot as well. The demo project includes three custom ShotView classes: WideShot, MediumShot, and CloseUp_ThoughtSpace.
  
 \section wideShot WideShot
  
 In the <code>initWithModel:controller:</code> method we see that touch control is enabled, and the Bus prop is instantiated. The <code>dealloc</code> method is likewise extended to handle cleanup of the Bus prop.
  
 A <code>ccTouchesEnded:withEvent:</code> method is added to handle touch controls, enabling the user to cut to the medium shot by tapping on the bus. Note that the tap action is mapped to the "zoomIn" adjacent shot tag established in the narrative script. When a tap occurs, the shot is queried for an adjacent shot which matches that tag, and if one is found, it becomes the new active shot. You could of course also query the model for a specific shot directly, but this level of abstraction makes it possible for the same tag ("zoomIn") to be applied across multiple shots (from wide shot to medium shot, and from medium shot to close-up, for example).
  
 The <code>update:</code> method is called every frame by the NarrativeView and updates the Bus prop in turn.
  
 \section mediumShot MediumShot
  
 In the <code>initWithModel:controller:</code> method for this class, two prop views (BusInterior_MS and Hat) and two actor views (Girl_MS and Man_MS) are instantiated and added to the scene.
  
 The <code>ccTouchesBegan:withEvent:</code> method keeps track of when and where touches occur, and checks to see specifically if the user touched the hat prop. If it was touched, then the girl's thoughts are directed to the topic associated with the hat prop (with a toggling behavior).
  
 The <code>ccTouchesMoved:withEvent:</code> method correlates vertical and horizontal motion with the movement of the girl's head, and pich in/out gestures with changes to her stance.
  
 The <code>ccTouchesEnded:withEvent:</code> method checks for taps that might trigger a zoom in to the next shot, or a zoom out to the previous shot. In addition, it handles changes to the girl's emotional transparency with respect to the current topic she's thinking about—changes driven by any change in stance effected by the use of a pinch in/out gesture.
  
 The <code>update:</code> method is called every frame by the NarrativeView and updates the relevant prop and actor views in turn.
  
 \section closeUp CloseUp_ThoughtSpace
  
 This ShotView is unique in that it actually renders two shots defined in the narrative script as "closeUpShot" and "thoughtSpaceShot". This is done so that a smooth, seamless transition can be had as the user transitions from one shot to the other, while maintaining their formal definition as separate shots with different characteristics. 
  
 The "thought space" is intended to be a place where the player can alter the girl's internal emotions about specific topics. Each topic shown floating in the space can be tapped and then gestures used to alter how the girl feels about the topic. Because the narrative script designates the thoughtSpaceShot as an "internal" shot, any modifications made to the girl's emotions affect her inner feelings about the selected topic, as opposed to the external expressions of those feelings (which can be modified in the medium shot).
  
 In the <code>initWithModel:controller:</code> method for this class, the BusInterior_CU and Girl_CU views are added to the scene. In addition, views for all topics defined in the narrative script (there's only one) are added programmatically, by deriving the name of the TopicView class from the name of the topic in the script.
  
 The <code>ccTouchesBegan:withEvent</code> method handles the selection and deselection of topic views and the resulting updates to the topic the girl actor is currently thinking about.
  
 The <code>ccTouchesMoved:withEvent</code> method tracks the execution of the "smile" and "frown" gestures which will modify how the girl feels about the selected topic, as well as the two-finger swipe gesture which trigger a gradual transition between the close-up and thought space shots.
  
 The <code>ccTouchesEnded:withEvent</code> method handles completion of the various gestures.
  
 The <code>setCurrentShot:</code> method keeps track of the currently active shot.
  
 The <code>update:</code> method is called every frame by the NarrativeView and updates the relevant prop, actor and topic views in turn.
  
 */

 //-----------------------------------------------------------

 /*! \page actorView Extending the ActorView Class
 
 The ActorView class is responsible for rendering a particular actor. It is an abstract class that must be extended in order to present specific media and interactivity for each actor, and often for each shot in which the actor appears (as the representational requirements may differ greatly by shot). The demo project includes three custom ActorView classes: Girl_MS, Man_MS, and Girl_CU.
  
 \section girlMS Girl_MS
  
 In the <code>initWithModel:controller:</code> method for this class, setup for the actor's sprites is accomplished, along with some state variable initialization.
  
 The <code>update:</code> is called every frame by the MediumShot class, and udpates the display of the sprite for the actor according to current state.
  
 Various other utility methods have been added to facilitate state updates which drive the sprite animation.
  
 \section manMS Man_MS
  
 This class really just presents a single static sprite for the actor.
  
 \section girlCU Girl_CU
  
 In the <code>initWithModel:controller:</code> method for this class, setup for the actor's sprites is accomplished, along with some state variable initialization.
  
 The <code>update:</code> is called every frame by the CloseUp_ThoughtSpace class, and udpates the display of the sprite for the actor according to current state across both shots represented in that ShotView class.
  
 Various other utility methods have been added to facilitate state updates which drive the sprite animation.
  
 */

 //-----------------------------------------------------------

 /*! \page propView Extending the PropView Class
  
 The PropView class is reponsible for rendering a particular prop. It is an abstract class that must be extended in order to present specific media and interactivity for each prop. The demo project includes four custom PropView classes: Bus, BusInterior_MS, Hat, and BusInterior_CU.
  
 \section bus Bus
  
 This class really just presents a single static sprite for the bus. Note that the <code>boundingBox</code> method has been overridden to provide a tap target for the WideShot class to use as it figures out what the user tapped on.
  
 \section busInteriorMS BusInterior_MS
  
 This class really just presents a single static sprite for the bus—it could just as easily been integrated into the MediumShot class.
  
 \section hat Hat
  
 The class presents a sprite for the hat, and also includes some additional highlighting logic depending on whether the girl actor is currently thinking about the topic associated with the prop.
  
 \section busInteriorCU BusInterior_CU
  
 This class presents a sprite for the bus interior as it appears in the background of the close-up shot, which adjusts in opacity depending on the state of the transition between the close-up and thought space shots.
  
 */

 //-----------------------------------------------------------

 /*! \page topicView Extending the TopicView Class
  
 The TopicView class handles rendering of a particular topic. It is an abstract class that must be extended in order to present specific media and interactivity for each topic. The demo project includes a DynamicTopicView class which is also an abstract class, extended further by the HatTopic class.
  
 \section dynamicTopicView DynamicTopicView
  
 This abstract class adds a single <code>transState</code> property which is related to the progress of the transition between the close-up and thought space shots, and is used to drive the opacity of the view. The idea is for all topics which are to be shown in the thought space to inherit from this class so their opacity transitions are all handled in the same way.
  
 \section hatTopic HatTopic
  
 This class presents a sprite for the hat topic, adjusting its opacity depending on the value of the <code>transState</code> property. The sprite rotates constantly and receives a colored highlight depending on whether the girl actor is thinking about its topic or not.
  
 */

 //-----------------------------------------------------------

 /*! \page customCommands Implementing Custom Event Atom Commands

 You don't need to be limited by the event atom commands that are natively supported in GeNIE; you can define your own commands within your narrative script and then handle them in your views when they occur. Here's how.
  
 First, define the custom command as an event atom somewhere in your narrative script:
  
 &nbsp;&nbsp;<code><eventAtom itemRef="myActor" command="sitDown"/></code>
  
 Since the <code>itemRef</code> property refers to an actor, the most logical place to handle this command would be in the corresponding ActorView subclass (let's call it MyActorView).
  
 Whenever an event atom is executed, the NarrativeModel sends a message to all of its observers. By making MyActorView an observer of NarrativeModel, it too can recive these messages and respond appropriately.
  
 In the <code>initWithController:</code> method of MyActorView, add the following:
  
 &nbsp;&nbsp;<code>[[NarrativeModel sharedInstance] addObserver:self];</code>
  
 Then, add the following method to MyActorView:
  
 <code>
 &nbsp;&nbsp;- (void) executeEventAtom:(EventAtom *)eventAtom {<br>
 &nbsp;&nbsp;&nbsp;&nbsp;if ([eventAtom.command isEqualToString:\@"sitDown"]) {<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;// Portray the actor sitting down<br>
 &nbsp;&nbsp;&nbsp;&nbsp;}<br>
 &nbsp;&nbsp;}
 </code>
  
 That's it—now MyActorView will respond to the custom event atom command.
 
 */

//
//  Globals.h
//  GeNIE
//
//  Created by Erik Loyer on 11/29/10.
//  Copyright 2010-2011 D. Fox Harrell, Principal Investigator / MIT ICE Lab. All rights reserved.
//  This work is licensed under a Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License. Details: http://creativecommons.org/licenses/by-nc-nd/3.0/
//  

///
/// Global variables and functions.
///

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

CGFloat DegreesToRadians(CGFloat degrees);
CGFloat RadiansToDegrees(CGFloat radians);
CGFloat DistanceBetweenTwoPoints(CGPoint point1,CGPoint point2);
CGColorRef CreateDeviceRGBColor(CGFloat r, CGFloat g, CGFloat b, CGFloat a);
void HSVtoRGB( float *r, float *g, float *b, float h, float s, float v );