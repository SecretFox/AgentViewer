import com.GameInterface.AgentSystem;
import com.GameInterface.AgentSystemAgent;
import com.GameInterface.DistributedValue;
import com.Utils.Archive;
import mx.utils.Delegate;
class com.fox.AgentViewer.Main {

	private var AgentWindow:DistributedValue;
	private var HideOleg:DistributedValue;
	private var HideBoone:DistributedValue;
	static var AgentSources:Array =	[
		[113, "Agent Pack \n Dungeons"],
		[173, "Agent Pack \n Dungeons"],
		[174, "Agent Pack \n Dungeons"],
		[175, "Agent Pack \n Dungeons"],
		[179, "Agent Pack \n Dungeons"],
		[181, "Agent Pack \n Regionals"],
		[204, "Agent Pack \n Regionals"],
		[206, "Agent Pack \n Regionals"],
		[207, "Agent Pack \n Regionals"],
		[209, "Achievement: Global Network"],
		[211, "Achievement: Mission Coordinator"],
		[212, "Agent Mission Reward"],
		[213, "Agent Mission Reward"],
		[214, "Scenarios"],
		[215, "Agent Pack \n Solomon, Kaidan Mains"],
		[217, "Agent Pack \n Solomon, Egypt Mains"],
		[218, "New York Raid"],
		[221, "Agent Mission Reward"],
		[223, "Agent Mission Reward"],
		[224, "Scenario"],
		[225, "Agent Mission Reward"],
		[226, "Agent Pack \n Egypt, Transylvania Mains"],
		[227, "Agent Pack \n Kaidan, South Africa Mains"],
		[228, "Agent Pack \n Solomon, Egypt Mains"],
		[229, "Scenarios"],
		[230, "Regionals"],
		[231, "Egypt, Transylvania Mains"],
		[233, "Agent Pack \n Egypt, Transylvania Mains"],
		[234, "Agent Pack \n Solomon, Egypt Mains"],
		[235, "Scenarios"],
		[236, "Solomon, Egypt Mains"],
		[238, "Agent Mission Reward"],
		[239, "Agent Pack \n Egypt, Transylvania Mains"],
		[240, "Agent Pack \n Kaidan, South Africa Mains"],
		[241, "Solomon, Egypt Mains"],
		[242, "Agent Pack \n Egypt, Transylvania Mains"],
		[244, "Kaidan, South Africa Mains"],
		[245, "Kaidan, South Africa Mains"],
		[246, "Scenarios"],
		[264, "Tutorial"],
		[2441, "SA Agent Pack"],
		[2449, "SA Agent Pack"],
		[2451, "SA Agent Pack \n South Africa Mains"],
		[2452, "SA Agent Pack \n South Africa Mains"],
		[2453, "Achievement: Night Terrors"],
		[2456, "Achievement: The Purge"],
		[2457, "SA Agent Pack \n South Africa Mains"],
		[2467, "SA Agent Pack \n South Africa Mains"],
		[2468, "SA Agent Pack \n South Africa Mains"],
		[2681, "DotM Collector's Edition"],
		[2701, "Achievement: Greenhorn"],
		[2722, "Dragon Faction Mission"],
		[2721, "Templar Faction Mission"],
		[2723, "Illuminati Faction mission"],
		
		//scenario
		[2761, "Community events"],//jack
		[2741, "Druids of Avalon Pack"],//Sif
		[2747, "Druids of Avalon Pack"],//Lynch
		[2742, "Druids of Avalon Pack \n Occult Defence scenario"],//Finn
		[2743, "Druids of Avalon Pack \n Occult Defence scenario"],//Laughing
		[2744, "Druids of Avalon Pack \n Occult Defence scenario"],//Francis
		[2745, "Druids of Avalon Pack \n Occult Defence scenario"],//Amelia
		[2746, "Druids of Avalon Pack \n Occult Defence scenario"],//Nuala
		[2748, "Druids of Avalon Pack \n Occult Defence scenario"],//Brann
		[2749, "Druids of Avalon Pack \n Occult Defence scenario"],//Fearghas
		[2750, "Occult Defence scenario?"],//Lady
		[2791, "Agent Mission Reward"]//Jerónimo
	];
	public static function main(swfRoot:MovieClip):Void {
		var s_app = new Main(swfRoot);
		swfRoot.onLoad = function() {s_app.Load()};
		swfRoot.onUnload = function() {s_app.UnLoad()};
		swfRoot.OnModuleActivated = function(config:Archive) { s_app.Activate(config); };
		swfRoot.OnModuleDeactivated = function() { return s_app.Deactivate(); };
	}

	public function Activate(config:Archive) {
		HideOleg.SetValue(Boolean(config.FindEntry("Oleg", false)));
		HideBoone.SetValue(Boolean(config.FindEntry("Faction", false)));
	}
	public function Deactivate():Archive {
		var conf:Archive = new Archive();
		conf.AddEntry("Oleg", HideOleg.GetValue());
		conf.AddEntry("Faction", HideBoone.GetValue());
		return conf
	}

	public function Main() {
		AgentWindow = DistributedValue.Create("agentSystem_window");
		HideOleg = DistributedValue.Create("AgentViewer_HideOleg");
		HideBoone = DistributedValue.Create("AgentViewer_HideBoone");
		HideOleg.SetValue(false);
		HideBoone.SetValue(false);
		if (_global.com.fox.AgentViewer.Hooked == undefined) _global.com.fox.AgentViewer.Hooked = false;
	}
	public function Load() {
		AgentWindow.SignalChanged.Connect(Hook, this);
		HideOleg.SignalChanged.Connect(SettingsChanged, this);
		HideBoone.SignalChanged.Connect(SettingsChanged, this);
		Hook();
	}

	public function UnLoad() {
		AgentWindow.SignalChanged.Disconnect(Hook, this);
		HideOleg.SignalChanged.Disconnect(SettingsChanged, this);
		HideBoone.SignalChanged.Disconnect(SettingsChanged, this);
	}
	// Hidden agenst are removed from m_AllAgents, need fresh array when settings change
	private function SettingsChanged(){
		if (AgentWindow.GetValue()){
			_root.agentsystem.m_Window.m_Content.m_Roster.m_AllAgents =  AgentSystem.GetAgents();
			_root.agentsystem.m_Window.m_Content.m_Roster["SortChanged"]();
		}
	}
	private function Hook() {
		if (AgentWindow.GetValue()) {
			if (_global.GUI.AgentSystem.RosterIcon.prototype.LoadPortrait && _root.agentsystem.m_Window.m_Content.m_Roster) {
				if (!_global.com.fox.AgentViewer.Hooked) {
				// RosterIcon.UpdateVisuals
					var f:Function = function() {
						arguments.callee.base.apply(this, arguments);
						if (!this.m_PortraitMode) {
							this.m_Name._visible = true;
						}
						//used for screenshot for AgentMittens
						/*
						
						this.m_Away._visible = false;
						this.m_Timer._visible = false;
						this.m_Level._visible = false;
						this.m_Stat1._visible = false;
						this.m_Stat2._visible = false;
						this.m_Stat3._visible = false;
						this.m_TraitCategories._visible = false;
						this.m_Foil._visible = false;
						this.m_Frame.m_Frame._visible = false;
						this._alpha = 100;
						*/
					};
					f.base = _global.GUI.AgentSystem.RosterIcon.prototype.UpdateVisuals;
					_global.GUI.AgentSystem.RosterIcon.prototype.UpdateVisuals = f;
				// RosterIcon.UpdatePortraitVisibility
					f = function() {
						arguments.callee.base.apply(this, arguments);
						this.m_Frame.m_Portrait._visible = true;
						this.m_Frame.m_Unowned._visible = !this.m_Frame.m_Portrait._visible;
					};
					f.base = _global.GUI.AgentSystem.RosterIcon.prototype.UpdatePortraitVisibility;
					_global.GUI.AgentSystem.RosterIcon.prototype.UpdatePortraitVisibility = f;
					for (var i in _root.agentsystem.m_Window.m_Content.m_Roster) {
						var agentIcon:MovieClip = _root.agentsystem.m_Window.m_Content.m_Roster[i];
						agentIcon["UpdateVisuals"]();
					}
				// Roster.OnAgentSelected
				// I still want to call original function in case it changes or other mods use it
				// PS: Sending the same signal twice breaks things, so only sending it for unowned agents
					f = function(event:Object) {
						arguments.callee.base.apply(this, arguments);
						var agentData:AgentSystemAgent = this.m_TileList.dataProvider[this.m_TileList.selectedIndex];
						if (!AgentSystem.HasAgent(agentData.m_AgentId)) {
							this.SignalAgentSelected.Emit(agentData)
						}
					};
					f.base = _global.GUI.AgentSystem.Roster.prototype.OnAgentSelected;
					_global.GUI.AgentSystem.Roster.prototype.OnAgentSelected = f;
				// 	Roster.FilterAgents
				//	Hides Oleg and agents that belong to other faction if user has configured the mod to do so
				// 	No need to call this function at start, sortChanged() will take care of it.
					f = function(pageNum:Number) {
						var HideOleg = com.GameInterface.DistributedValueBase.GetDValue("AgentViewer_HideOleg");
						var HideBoone = com.GameInterface.DistributedValueBase.GetDValue("AgentViewer_HideBoone");
						if (HideOleg || HideBoone) {
							var PlayerFaction = com.GameInterface.Game.Character.GetClientCharacter().GetStat(_global.Enums.Stat.e_PlayerFaction);
							for (var i in this.m_AllAgents) {
								if (HideOleg && this.m_AllAgents[i].m_AgentId == 2681) {
									this.m_AllAgents.splice(i,1);
									continue
								}
								if (HideBoone && this.m_AllAgents[i].m_AgentId == 2761) {
									this.m_AllAgents.splice(i,1);
									continue
								}
							}
						}
						return arguments.callee.base.apply(this, arguments);
					};
					f.base = _global.GUI.AgentSystem.Roster.prototype.FilterAgents;
					_global.GUI.AgentSystem.Roster.prototype.FilterAgents = f;
				// Roster.SortChanged
				/* Sorts all agents without differentiating between owned/unowned agents.
				 * Result is a mess where unowned/owned agents are mixed, calling original function will then separate them to owned and unowned agents, sorts owned, and combines the two arrays.
				 * Since m_AllAgents is looped through in order, unowned agents will now be in proper order aswell.
				*/
					f = function() {
						this.m_SortType = this.m_SortDropdown.selectedIndex;
						this.m_SortObject = {
							fields:this.m_SortDropdown.dataProvider[this.m_SortType].sortObj,
							options:this.m_SortDropdown.dataProvider[this.m_SortType].sortOption
						};
						this.m_AllAgents.sortOn(this.m_SortObject.fields, this.m_SortObject.options);
						arguments.callee.base.apply(this, arguments);
					};
					f.base = _global.GUI.AgentSystem.Roster.prototype.SortChanged;
					_global.GUI.AgentSystem.Roster.prototype.SortChanged = f;
					_root.agentsystem.m_Window.m_Content.m_Roster.SortChanged();
				// AgentInfo.SetData
					f = function(agentData:AgentSystemAgent) {
						arguments.callee.base.apply(this, arguments);
						if (!this.m_EquipmentTrait.text) {
							this.m_Stat1.m_Value.text = agentData.m_Stat1.toString();
							this.m_Stat2.m_Value.text = agentData.m_Stat2.toString();
							this.m_Stat3.m_Value.text = agentData.m_Stat3.toString();
							this.m_EquipmentTraitCategory.text = "Source";
							for (var i in Main.AgentSources){
								if (Main.AgentSources[i][0] == agentData.m_AgentId) {
									this.m_EquipmentTrait.text = Main.AgentSources[i][1];
								}
							}
							if(!this.m_EquipmentTrait.text) this.m_EquipmentTrait.text = "Unkown";
							this.m_EquipmentTrait.autoSize = "right";
						}
						var prev:MovieClip = this.attachMovie("Button_prevArrow", "m_Prev", this.getNextHighestDepth());
						prev._y = this.m_Name._y + 3;
						prev._x = this.m_Background._width / 2 - prev._width * 2;
						
						var next:MovieClip = this.attachMovie("Button_nextArrow", "m_Next", this.getNextHighestDepth());
						next._y = prev._y;
						next._x = this.m_Background._width / 2 + prev._width;
						
						prev.addEventListener("click", this, "prevAgent");
						next.addEventListener("click", this, "nextAgent");
					};
					f.base = _global.GUI.AgentSystem.AgentInfo.prototype.SetData;
					_global.GUI.AgentSystem.AgentInfo.prototype.SetData = f;
					
					_global.GUI.AgentSystem.AgentInfo.prototype.prevAgent = function ():Void {
						var Agents:Array = _root.agentsystem.m_Window.m_Content.m_Roster.m_AllAgents;
						var current:Number = this.m_AgentData.m_AgentId;
						for (var i:Number = 0; i < Agents.length; i++){
							if (Agents[i].m_AgentId == current){
								if (Agents[i - 1]){
									_root.agentsystem.m_Window.m_Content["SlotAgentSelected"](Agents[i - 1]);
								}
							}
						}
					}
					_global.GUI.AgentSystem.AgentInfo.prototype.nextAgent = function ():Void {
						var Agents = _root.agentsystem.m_Window.m_Content.m_Roster.m_AllAgents;
						var current = this.m_AgentData.m_AgentId;
						for (var i:Number = 0; i < Agents.length; i++){
							if (Agents[i].m_AgentId == current){
								if (Agents[i + 1]){
									_root.agentsystem.m_Window.m_Content["SlotAgentSelected"](Agents[i + 1]);
								}
							}
						}
					}
					
				// set to true so we know everything is hooked
					_global.com.fox.AgentViewer.Hooked = true;
				}
			} else {
				setTimeout(Delegate.create(this, Hook), 50);
			}
		}
	}
}