import com.GameInterface.AgentSystem;
import com.GameInterface.AgentSystemAgent;
import com.GameInterface.DistributedValue;
import com.Utils.Archive;
import mx.utils.Delegate;
class com.fox.AgentViewer.Main {

	private var AgentWindow:DistributedValue;
	private var HideOleg:DistributedValue;
	private var HideFactionAgents:DistributedValue;
	static var AgentSources:Object;
	public static function main(swfRoot:MovieClip):Void {
		var s_app = new Main(swfRoot);
		swfRoot.onLoad = function() {s_app.Load()};
		swfRoot.onUnload = function() {s_app.UnLoad()};
		swfRoot.OnModuleActivated = function(config:Archive) { s_app.Activate(config); };
		swfRoot.OnModuleDeactivated = function() { return s_app.Deactivate(); };
	}

	public function Activate(config:Archive) {
		HideOleg.SetValue(Boolean(config.FindEntry("Oleg", false)));
		HideFactionAgents.SetValue(Boolean(config.FindEntry("Faction", false)));
	}
	public function Deactivate():Archive {
		var conf:Archive = new Archive();
		conf.AddEntry("Oleg", HideOleg.GetValue());
		conf.AddEntry("Faction", HideFactionAgents.GetValue());
		return conf
	}

	public function Main() {
		AgentWindow = DistributedValue.Create("agentSystem_window");
		HideOleg = DistributedValue.Create("AgentViewer_HideOleg");
		HideFactionAgents = DistributedValue.Create("AgentViewer_HideFactionAgents");
		HideOleg.SetValue(false);
		HideFactionAgents.SetValue(false);
		AgentSources = new Object();
		AgentSources["113"] = "Agent Pack \n Dungeons";
		AgentSources["173"] = "Agent Pack \n Dungeons";
		AgentSources["174"] = "Agent Pack \n Dungeons";
		AgentSources["175"] = "Agent Pack \n Dungeons";
		AgentSources["179"] = "Agent Pack \n Dungeons";
		AgentSources["181"] = "Agent Pack \n Regionals";
		AgentSources["204"] = "Agent Pack \n Regionals";
		AgentSources["206"] = "Agent Pack \n Regionals";
		AgentSources["207"] = "Agent Pack \n Regionals";
		AgentSources["209"] = "Achievement: Global Network";
		AgentSources["211"] = "Achievement: Mission Coordinator";
		AgentSources["212"] = "Agent Mission Reward";
		AgentSources["213"] = "Agent Mission Reward";
		AgentSources["214"] = "Scenarios";
		AgentSources["215"] = "Agent Pack \n Solomon, Kaidan Mains";
		AgentSources["217"] = "Agent Pack \n Solomon, Egypt Mains";
		AgentSources["218"] = "New York Raid";
		AgentSources["221"] = "Agent Mission Reward";
		AgentSources["223"] = "Agent Mission Reward";
		AgentSources["224"] = "Scenario";
		AgentSources["225"] = "Agent Mission Reward";
		AgentSources["226"] = "Agent Pack \n Egypt, Transylvania Mains";
		AgentSources["227"] = "Agent Pack \n Kaidan, South Africa Mains";
		AgentSources["228"] = "Agent Pack \n Solomon, Egypt Mains";
		AgentSources["229"] = "Scenarios";
		AgentSources["230"] = "Regionals";
		AgentSources["231"] = "Egypt, Transylvania Mains";
		AgentSources["233"] = "Agent Pack \n Egypt, Transylvania Mains";
		AgentSources["234"] = "Agent Pack \n Solomon, Egypt Mains";
		AgentSources["235"] = "Scenarios";
		AgentSources["236"] = "Solomon, Egypt Mains";
		AgentSources["238"] = "Agent Mission Reward";
		AgentSources["239"] = "Agent Pack \n Egypt, Transylvania Mains";
		AgentSources["240"] = "Agent Pack \n Kaidan, South Africa Mains";
		AgentSources["241"] = "Solomon, Egypt Mains";
		AgentSources["242"] = "Agent Pack \n Egypt, Transylvania Mains";
		AgentSources["244"] = "Kaidan, South Africa Mains";
		AgentSources["245"] = "Kaidan, South Africa Mains";
		AgentSources["246"] = "Scenarios";
		AgentSources["264"] = "Tutorial";
		AgentSources["2441"] = "SA Agent Pack";
		AgentSources["2449"] = "SA Agent Pack";
		AgentSources["2451"] = "SA Agent Pack \n South Africa Mains";
		AgentSources["2452"] = "SA Agent Pack \n South Africa Mains";
		AgentSources["2453"] = "Achievement: Night Terrors";
		AgentSources["2456"] = "Achievement: The Purge";
		AgentSources["2457"] = "SA Agent Pack \n South Africa Mains";
		AgentSources["2467"] = "SA Agent Pack \n South Africa Mains";
		AgentSources["2468"] = "SA Agent Pack \n South Africa Mains";
		AgentSources["2681"] = "DotM Collector's Edition";
		AgentSources["2701"] = "Achievement: Greenhorn";
		
		AgentSources["2722"] = "Dragon Faction Mission";
		AgentSources["2721"] = "Templar Faction Mission";
		AgentSources["2723"] = "Illuminati Faction mission";
		if (_global.com.fox.AgentViewer.Hooked == undefined) _global.com.fox.AgentViewer.Hooked = false;
	}
	public function Load() {
		AgentWindow.SignalChanged.Connect(Hook, this);
		HideOleg.SignalChanged.Connect(SettingsChanged, this);
		HideFactionAgents.SignalChanged.Connect(SettingsChanged, this);
		Hook();
	}

	public function UnLoad() {
		AgentWindow.SignalChanged.Disconnect(Hook, this);
		HideOleg.SignalChanged.Disconnect(SettingsChanged, this);
		HideFactionAgents.SignalChanged.Disconnect(SettingsChanged, this);
	}
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
				// PS: Sending the same signal twice breaks things
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
						var HideFactionAgents = com.GameInterface.DistributedValueBase.GetDValue("AgentViewer_HideFactionAgents");
						if (HideOleg || HideFactionAgents) {
							var PlayerFaction = com.GameInterface.Game.Character.GetClientCharacter().GetStat(_global.Enums.Stat.e_PlayerFaction);
							for (var i in this.m_AllAgents) {
								if (HideOleg && this.m_AllAgents[i].m_AgentId == 2681) {
									delete this.m_AllAgents[i];
									continue
								}
								if (HideFactionAgents) {
									switch (PlayerFaction) {
										case _global.Enums.Factions.e_FactionDragon:
											if (this.m_AllAgents[i].m_AgentId == 2723 || this.m_AllAgents[i].m_AgentId == 2721) delete this.m_AllAgents[i];
											break;
										case _global.Enums.Factions.e_FactionTemplar:
											if (this.m_AllAgents[i].m_AgentId == 2723 || this.m_AllAgents[i].m_AgentId == 2722) delete this.m_AllAgents[i];
											break;
										case _global.Enums.Factions.e_FactionIlluminati:
											if (this.m_AllAgents[i].m_AgentId == 2721 || this.m_AllAgents[i].m_AgentId == 2722) delete this.m_AllAgents[i];
											break;
									}
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
						if (!AgentSystem.HasAgent(agentData.m_AgentId)) {
							this.m_Stat1.m_Value.text = agentData.m_Stat1.toString();
							this.m_Stat2.m_Value.text = agentData.m_Stat2.toString();
							this.m_Stat3.m_Value.text = agentData.m_Stat3.toString();
							this.m_EquipmentTraitCategory.text = "Source";
							if (Main.AgentSources[agentData.m_AgentId.toString()]) this.m_EquipmentTrait.text = Main.AgentSources[agentData.m_AgentId.toString()];
							else this.m_EquipmentTrait.text = "Unkown";
							this.m_EquipmentTrait.autoSize = "right";
						}
					};
					f.base = _global.GUI.AgentSystem.AgentInfo.prototype.SetData;
					_global.GUI.AgentSystem.AgentInfo.prototype.SetData = f;
				// set to true so we know everything is hooked
					_global.com.fox.AgentViewer.Hooked = true;
				}
			} else {
				setTimeout(Delegate.create(this, Hook), 50);
			}
		}
	}
}