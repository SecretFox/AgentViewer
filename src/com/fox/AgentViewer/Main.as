import com.GameInterface.AgentSystem;
import com.GameInterface.AgentSystemAgent;
import com.GameInterface.DistributedValue;
import mx.utils.Delegate;
class com.fox.AgentViewer.Main {

	private var AgentWindow:DistributedValue;
	static var AgentSources:Object = new Object();
	public static function main(swfRoot:MovieClip):Void {
		var s_app = new Main(swfRoot);
		swfRoot.onLoad = function() {s_app.Load()};
		swfRoot.onUnload = function() {s_app.UnLoad()};
	}

	public function Main() {
		AgentWindow = DistributedValue.Create("agentSystem_window");
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
		AgentSources["244"] = "Kaidan \n South Africa Mains";
		AgentSources["245"] = "Kaidan \n South Africa Mains";
		AgentSources["246"] = "Scenarios";
		AgentSources["264"] = "Tutorial";
		AgentSources["2441"] = "SA Agent Pack";
		AgentSources["2446"] = "Unkown";
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
	}

	public function Load() {
		AgentWindow.SignalChanged.Connect(Hook, this);
	}

	public function UnLoad() {
		AgentWindow.SignalChanged.Disconnect(Hook, this);
	}
	private function Hook() {
		if (AgentWindow.GetValue()) {
			if (_global.GUI.AgentSystem.RosterIcon.prototype.LoadPortrait && _root.agentsystem.m_Window.m_Content.m_Roster) {
				if (!_global.GUI.AgentSystem.RosterIcon.prototype._UpdateVisuals) {
					_global.GUI.AgentSystem.RosterIcon.prototype._UpdateVisuals = _global.GUI.AgentSystem.RosterIcon.prototype.UpdateVisuals;
					_global.GUI.AgentSystem.RosterIcon.prototype.UpdateVisuals = function() {
						this._UpdateVisuals();
						if (!this.m_PortraitMode) {
							this.m_Name._visible = true;
						}
					}
				}
				if (!_global.GUI.AgentSystem.RosterIcon.prototype._UpdatePortraitVisibility){
					_global.GUI.AgentSystem.RosterIcon.prototype._UpdatePortraitVisibility = _global.GUI.AgentSystem.RosterIcon.prototype.UpdatePortraitVisibility;
					_global.GUI.AgentSystem.RosterIcon.prototype.UpdatePortraitVisibility = function () {
						this.m_Frame.m_Portrait._visible = true;
						this.m_Frame.m_Unowned._visible = !this.m_Frame.m_Portrait._visible;
					}
				}
				for (var i in _root.agentsystem.m_Window.m_Content.m_Roster) {
					var agentIcon:MovieClip = _root.agentsystem.m_Window.m_Content.m_Roster[i];
					agentIcon["UpdateVisuals"]();
				}
				if (!_global.GUI.AgentSystem.Roster.prototype._OnAgentSelected){
					_global.GUI.AgentSystem.Roster.prototype._OnAgentSelected = _global.GUI.AgentSystem.Roster.prototype.OnAgentSelected;
					_global.GUI.AgentSystem.Roster.prototype.OnAgentSelected = function(event:Object){
						var agentData = this.m_TileList.dataProvider[this.m_TileList.selectedIndex];
						this.SignalAgentSelected.Emit(agentData);
					}
				}
				if (!_global.GUI.AgentSystem.AgentInfo.prototype._SetData2){
					_global.GUI.AgentSystem.AgentInfo.prototype._SetData2 = _global.GUI.AgentSystem.AgentInfo.prototype.SetData;
					_global.GUI.AgentSystem.AgentInfo.prototype.SetData = function(agentData:AgentSystemAgent){
						this._SetData2(agentData);
						if (!AgentSystem.HasAgent(agentData.m_AgentId)){
							this.m_Stat1.m_Value.text = agentData.m_Stat1.toString();
							this.m_Stat2.m_Value.text = agentData.m_Stat2.toString();
							this.m_Stat3.m_Value.text = agentData.m_Stat3.toString();
							if (Main.AgentSources[agentData.m_AgentId.toString()]){
								var Source:MovieClip = this.createEmptyMovieClip("m_Source", this.getNextHighestDepth());
								Source._y =  this.m_Trait2Category._y * 2 - this.m_Trait1Category._y - 3;
								Source._x =  this.m_Trait2Category._x;
								
								var font:TextFormat = this.m_Trait2Category.getTextFormat();
								font.align = "right";
								
								var txt:TextField = Source.createTextField("m_Header", Source.getNextHighestDepth(), 0, 0, 165, 15);
								txt.embedFonts = true;
								txt.setNewTextFormat(font);
								txt.text = "Source";
								
								var txt2:TextField = Source.createTextField("m_Desc", Source.getNextHighestDepth(), -35, this.m_Trait2._y - this.m_Trait2Category._y-3, 200, 20);
								txt2.embedFonts = true;
								txt2.setNewTextFormat(this.m_Trait2.getTextFormat());
								txt2.text = Main.AgentSources[agentData.m_AgentId.toString()];
								txt2.verticalAutoSize = "true";
							}
							
						}
					}
				}
			} else {
				setTimeout(Delegate.create(this, Hook), 50);
			}
		}
	}
}