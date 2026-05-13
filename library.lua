CSK = ColorSequenceKeypoint.new;
NSK = NumberSequenceKeypoint.new;
BSP = Enum.BorderStrokePosition;
VA = Enum.VerticalAlignment;
ASM = Enum.ApplyStrokeMode;
UFA = Enum.UIFlexAlignment;
TXA = Enum.TextXAlignment;
TYA = Enum.TextYAlignment;
UIT = Enum.UserInputType;
TT = Enum.TextTruncate;
UFO = UDim2.fromOffset;
UFS = UDim2.fromScale;
RGB = Color3.fromHSV;
HSV = Color3.fromHSV;
GS = Enum.GuiState;
KC = Enum.KeyCode;
TCC = table.concat;
TIS = table.insert;
UD2 = UDim2.new;
TR = table.remove;
TU = table.unpack;
TC = table.clone;
TF = table.find;
MC = math.clamp;
MR = math.round;
MF = math.floor;
MM = math.min;
MH = math.huge;
ED = Enum.EasingDirection;
AS = Enum.AutomaticSize;
FD = Enum.FillDirection;
ES = Enum.EasingStyle;
FW = Enum.FontWeight;
SO = Enum.SortOrder;
FS = Enum.FontStyle;
EF = Enum.Font;
TI = TweenInfo.new;
SF = string.format;
V2 = Vector2.new;
V3 = Vector3.new;
UD = UDim.new;
FN = Font.new;
CS = ColorSequence.new;
NS = NumberSequence.new;
CF = CFrame.new;

local function New(class: string, properties: {}?, attributes: {}?): Instance | boolean
	local success, instance = pcall(Instance.new, class)

	if not success then
		return false
	end

	if properties then
		for key, value in next, properties do
			local succ, err = pcall(function()
				(instance :: any)[key] = value
			end)

			if not succ then
				return nil
			end
		end
	end

	if attributes then
		for key, value in pairs(attributes) do
			instance:SetAttribute(key, value)
		end
	end

	return instance
end

local Services = setmetatable({}, {
	__index = function(self, Reference)
		local Clone = cloneref(game:GetService(Reference))
		self[Reference] = Clone

		return Clone
	end
})

local Library = {
	Directory = 'your_directory_here';
	Instance = nil;
	Theme = nil;
	DragAllowed = true;

	Hotkey = KC.Tab;

	Methods = {};
	Elements = {};
	SubElements = {};
	Windows = {};
	Threads = {};
	Groups = {};
	Flags = {};

	Folders = { 'themes'; 'configs'; };
	Style = { [1] = 0.2569; [2] = ES.Quad; [3] = ED.Out;};

	Font = {
		Primary = FN('rbxasset://fonts/families/SourceSansPro.json', FW.Regular, FS.Normal);
		Secondary = FN('rbxasset://fonts/families/SourceSansPro.json', FW.Bold, FS.Normal);
		Size = 14;
		Stroke = 0;
	};

	Presets = {
		Default = {
			PrimaryAccent = RGB(84, 161, 255);
			SecondaryAccent = RGB(84, 161, 255);

			Background = RGB(255, 255, 255);
			Foreground = RGB(245, 245, 245);

			Inline = RGB(30, 30, 30);
			Outline = RGB(10, 10, 10);

			Text = RGB(0,0,0);
			TextStroke = RGB(0, 0, 0);
		};
	};
}
Library.Theme = Library.Presets.Default

local InputService = Services.UserInputService;
local TweenService = Services.TweenService;
local RunService = Services.RunService;
local Players = Services.Players;
local Http = Services.HttpService;
local Core = Services.CoreGui;

local Client = Players.LocalPlayer;
local Mouse = Client:GetMouse();

Library.SubElements.__index = Library.SubElements;
Library.Elements.__index = Library.Elements;
Library.Methods.__index = Library.Methods;
Library.__index = Library;

Library.Instance = New("ScreenGui", { Name = 'xd'; ResetOnSpawn = false; Parent = RunService:IsStudio() and Client.PlayerGui or Core, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })

do
	function Library:Overwrite(T1 : {}, T2 : {}) : {}
		for i, v in pairs(T2) do
			T1[i] = type(v) == 'table' and Library:Overwrite(T1[i] or {}, v) or v
		end

		return T1 or nil
	end
	
	function Library:EditColor(color : Color3, number : number) : Color3
		local h, s, v = color:ToHSV()
		v = MC(v + (number / 255), 0, 1)
		return HSV(h, s, v)
	end

	function Library:Validate(input_type : EnumItem)
		local Whitelist = {
			UIT.MouseMovement;
			UIT.MouseButton1;
			UIT.Touch;
		}

		for _, InputType in Whitelist do
			if input_type == InputType then
				return true
			end
		end

		return false
	end
end

do
	function Library.Elements:AddEspPreview(... : {})
		local ElementData = Library:Overwrite({
			Inputs = {};
			DefaultCF = CF(25.5, 6.5, -9.30000019, -1, 0, -6.27832947e-07, 0, 1, 0, 6.27832947e-07, 0, -1);
			LastMP = nil;
			Rig = nil;
		}, ... or {});

		local ViewportFrame = New("ViewportFrame", { Parent = self.Container; BackgroundTransparency = 1; Size = UD2(1, 24, 1, -24); Ambient = RGB(255, 255, 255); LightColor = RGB(100, 100, 100) })
		local ResetButton = New("TextButton", { Parent = ViewportFrame, Name = [[ResetButton]], BorderSizePixel = 0, AutoButtonColor = false, BackgroundColor3 = RGB(67, 48, 104), AnchorPoint = V2(0.5, 1), TextSize = 14, Size = UD2(0.349999994, 0, 0, 30), BorderColor3 = RGB(0, 0, 0), Text = [[]], FontFace = Library.Font.Primary, Position = UD2(0.5, 0, 1, 0), TextColor3 = RGB(0, 0, 0) })
		local TextLabel = New("TextLabel", { Parent = ResetButton, TextWrapped = true, ZIndex = 2, BorderSizePixel = 0, TextScaled = true, BackgroundColor3 = RGB(255, 255, 255), AnchorPoint = V2(0, 0.5), TextSize = 14, Size = UD2(1, 0, 0.5, 0), BorderColor3 = RGB(0, 0, 0), Text = [[Reset Camera]], FontFace = Library.Font.Secondary, Position = UD2(0, 0, 0.5, 0), TextColor3 = RGB(199, 191, 240), BackgroundTransparency = 1 })
		New("UICorner", { Parent = ResetButton, CornerRadius = UD(0, 2) })
		New("UIPadding", { Parent = TextLabel, PaddingRight = UD(0, 8), PaddingLeft = UD(0, 8) })
		New("UIPadding", { Parent = ResetButton,} )
		New("UIPadding", { Parent = ViewportFrame, PaddingBottom = UD(0, 12) })
		New("UIStroke", { Parent = TextLabel, Enabled = false, BorderOffset = UD(0, 0), BorderStrokePosition = BSP.Inner })
		New("UIStroke", { Parent = TextLabel, BorderOffset = UD(0, 0), Transparency = 0.25,} )
		New("UIStroke", { Parent = ResetButton, Enabled = false, BorderOffset = UD(0, 0), Color = RGB(36, 24, 59), ApplyStrokeMode = ASM.Border,} )

		local WorldModel = New('WorldModel', { Parent = ViewportFrame; Name = 'ViewportFrame'; })
		local ViewportCamera = New('Camera', { Parent = ViewportFrame; CFrame = CF(V3(25.5, 6, 0.7)); FieldOfView = 45, MaxAxisFieldOfView = 45; FieldOfViewMode = Enum.FieldOfViewMode.Vertical; CameraType = Enum.CameraType.Fixed })
		ViewportFrame.CurrentCamera = ViewportCamera

		ResetButton.Activated:Connect(function()
			ElementData.Rig.HumanoidRootPart.CFrame = (ElementData.DefaultCF)
		end)

		local function GetRoot(Rig : Model)
			if not Rig then
				return
			end

			if Rig.HumanoidRootPart then
				return Rig.HumanoidRootPart
			end

			return nil
		end

		function ElementData:UpdateRig(PlayerId : number)
			if ElementData.Rig then
				ElementData.Rig:Destroy();
			end

			local NewDescription = Players:GetHumanoidDescriptionFromUserIdAsync(PlayerId);
			local NewRig = Players:CreateHumanoidModelFromDescriptionAsync(
				NewDescription,
				Enum.HumanoidRigType.R6,
				'Default'
			);
			NewRig.Parent = WorldModel;
			ElementData.Rig = NewRig

			task.wait()

			for _, Track in NewRig:FindFirstChildOfClass('Humanoid'):GetPlayingAnimationTracks() do
				Track:Stop()
			end

			GetRoot(ElementData.Rig).CFrame = ElementData.DefaultCF
		end

		InputService.InputChanged:Connect(function(input, GPE)
			if Library:Validate(input.UserInputType) and Library.DragAllowed then
				if ElementData.Inputs["MouseButton1"] or ElementData.Inputs["Touch"] and ElementData.Rig then 
					local Current = V2(Mouse.X,Mouse.Y)
					local Delta = (Current - ElementData.LastMP)/1.5

					local Target = GetRoot(ElementData.Rig):GetPivot() * CFrame.Angles(0, math.rad(Delta.X), 0)
					GetRoot(ElementData.Rig).CFrame = Target

					ElementData.LastMP = Current
				end
			end
		end)

		InputService.InputBegan:Connect(function(input)
			if Library:Validate(input.UserInputType) and ViewportFrame.GuiState == Enum.GuiState.Press then
				ElementData.Inputs["MouseButton1"] = true
				ElementData.LastMP = V2(Mouse.X, Mouse.Y)
			end
		end)

		InputService.InputEnded:Connect(function(input)
			if Library:Validate(input.UserInputType) then
				ElementData.Inputs["MouseButton1"] = nil
				ElementData.LastMP = nil
			end
		end)

		ElementData:UpdateRig(Client.UserId)
		return ElementData
	end
	
	function Library.Elements:AddModelPreview(... : {})
		local ElementData = Library:Overwrite({
			Inputs = {};
			DefaultCF = CF(25.5, 6, -9.30000019, -1, 0, -6.27832947e-07, 0, 1, 0, 6.27832947e-07, 0, -1);
			LastMP = nil;
			Rig = nil;
			FOV = 20;
		}, ... or {});

		local ViewportFrame = New("ViewportFrame", { Parent = self.Container; BackgroundTransparency = 1; Size = UD2(1, 24, 1, -24); Ambient = RGB(255, 255, 255); LightColor = RGB(100, 100, 100) })
		local ResetButton = New("TextButton", { Parent = ViewportFrame, Name = [[ResetButton]], BorderSizePixel = 0, AutoButtonColor = false, BackgroundColor3 = RGB(67, 48, 104), AnchorPoint = V2(1, 1), TextSize = 14, Size = UD2(0.25, 0, 0, 30), BorderColor3 = RGB(0, 0, 0), Text = [[]], FontFace = Library.Font.Primary, Position = UD2(1, 0, 1, 12), TextColor3 = RGB(0, 0, 0) })
		local TextLabel = New("TextLabel", { Parent = ResetButton, TextWrapped = true, ZIndex = 2, BorderSizePixel = 0, TextScaled = true, BackgroundColor3 = RGB(255, 255, 255), AnchorPoint = V2(0, 0.5), TextSize = 14, Size = UD2(1, 0, 0.5, 0), BorderColor3 = RGB(0, 0, 0), Text = [[Reset]], FontFace = Library.Font.Secondary, Position = UD2(0, 0, 0.5, 0), TextColor3 = RGB(199, 191, 240), BackgroundTransparency = 1 })
		New("UICorner", { Parent = ResetButton, CornerRadius = UD(0, 2) })
		New("UIPadding", { Parent = TextLabel, PaddingRight = UD(0, 8), PaddingLeft = UD(0, 8) })
		New("UIPadding", { Parent = ResetButton,} )
		New("UIPadding", { Parent = ViewportFrame, PaddingBottom = UD(0, 12) })
		New("UIStroke", { Parent = TextLabel, Enabled = false, BorderOffset = UD(0, 0), BorderStrokePosition = BSP.Inner })
		New("UIStroke", { Parent = TextLabel, BorderOffset = UD(0, 0), Transparency = 0.25,} )
		New("UIStroke", { Parent = ResetButton, Enabled = false, BorderOffset = UD(0, 0), Color = RGB(36, 24, 59), ApplyStrokeMode = ASM.Border,} )

		local WorldModel = New('WorldModel', { Parent = ViewportFrame; Name = 'ViewportFrame'; })
		local ViewportCamera = New('Camera', { Parent = ViewportFrame; CFrame = CF(V3(25.5, 6, 0.7)); FieldOfView = ElementData.FOV, MaxAxisFieldOfView = ElementData.FOV; FieldOfViewMode = Enum.FieldOfViewMode.Vertical; CameraType = Enum.CameraType.Fixed })
		ViewportFrame.CurrentCamera = ViewportCamera

		ResetButton.Activated:Connect(function()
			ElementData.Rig:PivotTo(ElementData.DefaultCF)
		end)
		
		local DominantAxis = nil

		function ElementData:UpdateRig(NewModel : Instance)
			if not NewModel then
				return
			end
			
			if ElementData.Rig then
				ElementData.Rig:Destroy();
			end

			local NewRig = NewModel:Clone();
			NewRig.Parent = WorldModel;
			ElementData.Rig = NewRig
			
			local ExtentsSize = (NewRig:FindFirstChild('Gun') or NewRig:FindFirstChild('Knife')):GetExtentsSize()
			
			DominantAxis = (function()
				local axis = {
					x = ExtentsSize.X;
					y = ExtentsSize.Y;
					z = ExtentsSize.Z;
				};
				local max = 0;
				local dom = nil;
				
				for axis, num in next, axis do
					if num > max then
						max = num
						dom = axis
					end
				end
				
				if dom then
					return dom:upper()
				end
			end)()
			
			if DominantAxis == nil then
				DominantAxis = 'X'
			end
			
			if DominantAxis == 'Z' then
				ElementData.DefaultCF = CF(25.5, 6.05, -9.30000019, -1.31134158e-07, -1, -6.27832947e-07, -1, 1.31134158e-07, 0, 8.23303489e-14, 6.27832947e-07, -1)
			end
			
			ViewportCamera.FieldOfView = ExtentsSize[DominantAxis] * 2.5
			ViewportCamera.MaxAxisFieldOfView = ExtentsSize[DominantAxis] * 2.5
			--local focusPart = NewRig --// model that you want to add
			--local size = focusPart:GetExtentsSize()
			--ViewportCamera.CFrame = focusPart.WorldPivot * CF(0,size.Y*1.5,size.Z) * CFrame.Angles(math.rad(-45),0,0)

			ElementData.Rig:PivotTo(ElementData.DefaultCF)
		end

		InputService.InputChanged:Connect(function(input, GPE)
			if Library:Validate(input.UserInputType) and Library.DragAllowed then
				if ElementData.Inputs["MouseButton1"] or ElementData.Inputs["Touch"] and ElementData.Rig then 
					local Current = V2(Mouse.X,Mouse.Y)
					local Delta = (Current - ElementData.LastMP)/1.5
					local Target = nil;
					
					if DominantAxis == 'Z' then
						Target = ElementData.Rig:GetPivot() * CFrame.Angles(math.rad(Delta.X * -1), 0, 0)
					else
						Target = ElementData.Rig:GetPivot() * CFrame.Angles(0, math.rad(Delta.X), 0)
					end
					
					ElementData.Rig:PivotTo(Target)
					ElementData.LastMP = Current
				end
			end
		end)

		InputService.InputBegan:Connect(function(input)
			if Library:Validate(input.UserInputType) and ViewportFrame.GuiState == Enum.GuiState.Press then
				ElementData.Inputs["MouseButton1"] = true
				ElementData.LastMP = V2(Mouse.X, Mouse.Y)
			end
		end)

		InputService.InputEnded:Connect(function(input)
			if Library:Validate(input.UserInputType) then
				ElementData.Inputs["MouseButton1"] = nil
				ElementData.LastMP = nil
			end
		end)

		ElementData:UpdateRig(ElementData.Rig)
		return ElementData
	end
	
	function Library.Elements:AddColor(... : {})
		local ElementData = Library:Overwrite({
			Instance = nil;
			Float = nil;
			Draggable = true;
			Dropped = false;
			Colors = {};

			Text = 'Color Picker';
			Value = RGB(255, 255, 255);
			Flag = nil;
			RGB = false;
			Sync = false;
			Speed = 1;
			Alpha = 1;
			Callback = function() end;
		}, ... or {})
		--setmetatable(ElementData, Library)

		local ElementButton = New("TextButton", { Parent = self.SubContainer, Name = [[ColorPickerButton]], ZIndex = 2, BorderSizePixel = 0, AutoButtonColor = false, BackgroundColor3 = RGB(255, 255, 255), TextSize = 14, Size = UD2(1, 0, 1, 0), LayoutOrder = -999, BorderColor3 = RGB(0, 0, 0), Text = [[]], FontFace = Library.Font.Primary, TextColor3 = RGB(0, 0, 0) })
		local Gradient = New("Frame", { Parent = ElementButton, Name = [[Gradient]], AnchorPoint = V2(0.5, 0.5), BorderSizePixel = 0, Size = UD2(0.699999988, 0, 0.699999988, 0), BorderColor3 = RGB(0, 0, 0), Position = UD2(0.5, 0, 0.5, 0), BackgroundTransparency = 0.8500000238418579, BackgroundColor3 = RGB(0, 0, 0) })
		New("UIAspectRatioConstraint", { Parent = ElementButton })
		New("UICorner", { Parent = ElementButton, CornerRadius = UD(0, 4) })
		New("UIStroke", { Parent = ElementButton, BorderOffset = UD(0, 0), Color = RGB(13, 9, 25), ApplyStrokeMode = ASM.Border, Thickness = 2, ZIndex = 2, BorderStrokePosition = BSP.Inner })
		New("UIStroke", { Parent = ElementButton, BorderOffset = UD(0, 0), Color = RGB(85, 66, 115), ApplyStrokeMode = ASM.Border, ZIndex = 3, BorderStrokePosition = BSP.Inner,} )
		New("UIPadding", { Parent = ElementButton, PaddingTop = UD(0, 2), PaddingRight = UD(0, 2), PaddingLeft = UD(0, 2), PaddingBottom = UD(0, 2) })
		New("UIGradient", { Parent = ElementButton, Transparency = NS({ NSK(0, 0, 0); NSK(0.3741610646247864, 0, 0); NSK(1, 0.6499999761581421, 0);}), Rotation = 90,} )
		New("UIGradient", { Parent = Gradient, Transparency = NS({ NSK(0, 0, 0); NSK(1, 1, 0);}), Rotation = -90 })

		local ColorPickerFrame = New("Frame", { Parent = Library.Instance, Visible = false; Name = [[ColorPickerFrame]], ZIndex = 2, BorderSizePixel = 0, Size = UD2(0, 210, 0, 200), BorderColor3 = RGB(0, 0, 0), Position = UD2(0.650589347, 0, 0.243392572, 0), BackgroundColor3 = RGB(36, 24, 59) })
		local ColorMaps = New("Frame", { Parent = ColorPickerFrame, Name = [[ColorMaps]], ZIndex = 2, BorderSizePixel = 0, Size = UD2(1, 0, 1, -24), BorderColor3 = RGB(0, 0, 0), LayoutOrder = 999, BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })
		local ColorMap = New("Frame", { Parent = ColorMaps, Name = [[ColorMap]], ZIndex = 3, BorderSizePixel = 0, Size = UD2(1, 0, 1, 0), BorderColor3 = RGB(0, 0, 0), BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })
		local SatMap = New("Frame", { Parent = ColorMap, Name = [[SatMap]], BorderSizePixel = 0, Size = UD2(1, 0, 1, 0), BorderColor3 = RGB(0, 0, 0), BackgroundColor3 = RGB(255, 255, 255) })
		local SaturationGradient = New("UIGradient", { Parent = SatMap, Name = [[SatMapGradient]], Color = CS({ CSK(0, RGB(255, 255, 255)); CSK(1, RGB(255, 0, 0));}) })
		local ValMap = New("Frame", { Parent = ColorMap, Name = [[ValMap]], BorderSizePixel = 0, Size = UD2(1, 0, 1, 0), BorderColor3 = RGB(0, 0, 0), BackgroundColor3 = RGB(255, 255, 255) })
		local ValueGradient = New("UIGradient", { Parent = ValMap, Name = [[ValMapGradient]], Transparency = NS({ NSK(0, 1, 0); NSK(1, 0, 0);}), Rotation = 90, Color = CS({ CSK(0, RGB(255, 255, 255)); CSK(1, RGB(0, 0, 0));}) })
		local UIListLayout = New("UIListLayout", { Parent = ColorMaps, FillDirection = FD.Horizontal, HorizontalFlex = UFA.Fill, SortOrder = SO.LayoutOrder, Padding = UD(0, 6) })
		local HueBar = New("Frame", { Parent = ColorMaps, Name = [[HueBar]], ZIndex = 3, BorderSizePixel = 0, Size = UD2(0, 0, 1, 0), BorderColor3 = RGB(0, 0, 0), BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })
		local Hue = New("Frame", { Parent = HueBar, Name = [[Hue]], BorderSizePixel = 0, Size = UD2(1, 0, 1, 0), BorderColor3 = RGB(0, 0, 0), BackgroundColor3 = RGB(255, 255, 255) })
		local HueGradient = New("UIGradient", { Parent = Hue, Name = [[HueBarGradient]], Rotation = 90, Color = CS({ CSK(0, RGB(255, 0, 0)); CSK(0.16670000553131104, RGB(255, 255, 0)); CSK(0.3330000042915344, RGB(0, 255, 0)); CSK(0.5, RGB(0, 255, 255)); CSK(0.6695501804351807, RGB(0, 0, 255)); CSK(0.8330000042915344, RGB(255, 0, 255)); CSK(1, RGB(255, 0, 0));}) })
		local AlphaBar = New("Frame", { Parent = ColorMaps, Name = [[AlphaBar]], ZIndex = 3, BorderSizePixel = 0, Size = UD2(0, 0, 1, 0), BorderColor3 = RGB(0, 0, 0), BackgroundColor3 = RGB(255, 255, 255) })
		local Alp = New("Frame", { Parent = AlphaBar, Name = [[Alp]], ZIndex = 2, BorderSizePixel = 0, Size = UD2(1, 0, 1, 0), BorderColor3 = RGB(0, 0, 0), BackgroundColor3 = RGB(255, 0, 4) })
		local AlphaBarGradient = New("UIGradient", { Parent = Alp, Name = [[AlphaBarGradient]], Transparency = NS({ NSK(0, 0, 0); NSK(1, 1, 0);}), Rotation = 90 })
		local ImageLabel = New("ImageLabel", { Parent = AlphaBar, Image = [[rbxassetid://138299238074834]], TileSize = UD2(0, 14, 0, 14), BorderSizePixel = 0, Size = UD2(1, 0, 1, 0), ScaleType = Enum.ScaleType.Tile, BorderColor3 = RGB(0, 0, 0), ResampleMode = Enum.ResamplerMode.Pixelated, ImageTransparency = 0.75, ImageColor3 = RGB(0, 0, 0), BackgroundColor3 = RGB(255, 255, 255) })
		local PreviewBar = New("Frame", { Parent = ColorPickerFrame, Name = [[PreviewBar]], ZIndex = 3, BorderSizePixel = 0, Size = UD2(1, 0, 0, 24), BorderColor3 = RGB(0, 0, 0), BackgroundColor3 = RGB(36, 24, 59) })
		local PreviewButton = New("TextButton", { Parent = PreviewBar, Name = [[PreviewButton]], ZIndex = 2, BorderSizePixel = 0, AutoButtonColor = false, BackgroundColor3 = RGB(255, 0, 0), AnchorPoint = V2(1, 0), TextSize = 14, Size = UD2(1, 0, 1, 0), LayoutOrder = -999, BorderColor3 = RGB(0, 0, 0), Text = [[]], FontFace = Library.Font.Primary, Position = UD2(1, 0, 0, 0), TextColor3 = RGB(0, 0, 0) })
		local Frame = New("Frame", { Parent = PreviewButton, BorderSizePixel = 0, Size = UD2(1, 0, 1, 0), BorderColor3 = RGB(0, 0, 0), BackgroundTransparency = 0.8500000238418579, BackgroundColor3 = RGB(0, 0, 0) })
		local HexInput = New("TextBox", { Parent = PreviewBar, Name = [[HexInput]], PlaceholderColor3 = RGB(199, 191, 240), BorderSizePixel = 0, BackgroundColor3 = RGB(255, 255, 255), AnchorPoint = V2(0, 0.5), TextXAlignment = Enum.TextXAlignment.Left, TextSize = 14, Size = UD2(0.75, -16, 0.5, 0), TextColor3 = RGB(199, 191, 240), BorderColor3 = RGB(0, 0, 0), Text = [[FF0000]], FontFace = Library.Font.Secondary, Position = UD2(0, 0, 0.5, 0), BackgroundTransparency = 1 })

		local ColorMarker = New("Frame", { Parent = ColorMap, Name = [[MapMarker]], AnchorPoint = V2(0.5, 0.5), BorderSizePixel = 0, Size = UD2(0, 8, 0, 8), BorderColor3 = RGB(0, 0, 0), Position = UD2(1, 0, 1, 0), BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })
		local HueMarker = New("Frame", { Parent = HueBar, Name = [[HueMarker]], ZIndex = 2, BorderSizePixel = 0, Size = UD2(1, 0, 0, 5), BorderColor3 = RGB(0, 0, 0), BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })
		local AlphaMarker = New("Frame", { Parent = AlphaBar, Name = [[AlpMarker]], ZIndex = 2, BorderSizePixel = 0, Size = UD2(1, 0, 0, 5), BorderColor3 = RGB(0, 0, 0), BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })

		New("UIStroke", { Parent = ColorPickerFrame, Enabled = false, BorderOffset = UD(0, 0), Color = RGB(29, 19, 53), BorderStrokePosition = BSP.Inner })
		New("UIStroke", { Parent = ColorPickerFrame, BorderOffset = UD(0, 0), Color = RGB(85, 66, 115),} )
		New("UICorner", { Parent = ColorPickerFrame, CornerRadius = UD(0, 2) })
		New("UIAspectRatioConstraint", { Parent = ColorMap })
		New("UICorner", { Parent = SatMap, CornerRadius = UD(0, 5),} )
		New("UICorner", { Parent = ValMap, CornerRadius = UD(0, 4),} )
		New("UICorner", { Parent = ColorMap, CornerRadius = UD(0, 2),} )
		New("UIStroke", { Parent = ColorMap, BorderOffset = UD(0, 0), Color = RGB(85, 66, 115),} )
		New("UIStroke", { Parent = ColorMap, Enabled = false, BorderOffset = UD(0, 0), Color = RGB(29, 19, 53), BorderStrokePosition = BSP.Inner,} )
		New("UICorner", { Parent = ColorMarker, CornerRadius = UD(0, 3),} )
		New("UIStroke", { Parent = ColorMarker, BorderOffset = UD(0, 0), Color = RGB(255, 255, 255), Thickness = 1.649999976158142, BorderStrokePosition = BSP.Inner,} )
		New("UICorner", { Parent = HueBar, CornerRadius = UD(0, 3),} )
		New("UIStroke", { Parent = HueBar, BorderOffset = UD(0, 0), Color = RGB(85, 66, 115),} )
		New("UIStroke", { Parent = HueBar, Enabled = false, BorderOffset = UD(0, 0), Color = RGB(29, 19, 53), BorderStrokePosition = BSP.Inner,} )
		New("UIStroke", { Parent = HueMarker, BorderOffset = UD(0, 0), Color = RGB(255, 255, 255), Thickness = 0.8999999761581421, BorderStrokePosition = BSP.Inner,} )
		New("UICorner", { Parent = Hue, CornerRadius = UD(0, 3),} )
		New("UICorner", { Parent = Alp, CornerRadius = UD(0, 4),} )
		New("UICorner", { Parent = AlphaBar, CornerRadius = UD(0, 3),} )
		New("UICorner", { Parent = ImageLabel, CornerRadius = UD(0, 3),} )
		New("UICorner", { Parent = Frame, CornerRadius = UD(0, 3),} )
		New("UICorner", { Parent = PreviewBar, CornerRadius = UD(0, 2),} )
		New("UICorner", { Parent = PreviewButton, CornerRadius = UD(0, 2),} )
		New("UIStroke", { Parent = AlphaBar, BorderOffset = UD(0, 0), Color = RGB(85, 66, 115),} )
		New("UIStroke", { Parent = AlphaBar, Enabled = false, BorderOffset = UD(0, 0), Color = RGB(29, 19, 53), BorderStrokePosition = BSP.Inner,} )
		New("UIStroke", { Parent = AlphaMarker, BorderOffset = UD(0, 0), Color = RGB(255, 255, 255), BorderStrokePosition = BSP.Inner,} )
		New("UIStroke", { Parent = PreviewBar, Enabled = false, BorderOffset = UD(0, 0), Color = RGB(29, 19, 53), BorderStrokePosition = BSP.Inner,} )
		New("UIStroke", { Parent = PreviewBar, BorderOffset = UD(0, 0), Color = RGB(85, 66, 115),} )
		New("UIStroke", { Parent = PreviewButton, BorderOffset = UD(0, 0), Color = RGB(13, 9, 25), ApplyStrokeMode = ASM.Border, ZIndex = 2, BorderStrokePosition = BSP.Inner,} )
		New("UIStroke", { Parent = PreviewButton, BorderOffset = UD(0, 0), Color = RGB(85, 66, 115), ApplyStrokeMode = ASM.Border, ZIndex = 3,} )
		New("UIPadding", { Parent = PreviewButton, PaddingTop = UD(0, 2), PaddingRight = UD(0, 2), PaddingLeft = UD(0, 2), PaddingBottom = UD(0, 2) })
		New("UIPadding", { Parent = PreviewBar, PaddingTop = UD(0, 5), PaddingRight = UD(0, 4), PaddingLeft = UD(0, 8), PaddingBottom = UD(0, 5),} )
		New("UIPadding", { Parent = ColorPickerFrame, PaddingTop = UD(0, 6), PaddingRight = UD(0, 6), PaddingLeft = UD(0, 6), PaddingBottom = UD(0, 6),} )
		New("UIAspectRatioConstraint", { Parent = PreviewButton,} )
		New("UIListLayout", { Parent = ColorPickerFrame, SortOrder = SO.LayoutOrder, Padding = UD(0, 6), VerticalFlex = UFA.Fill,} )

		InputService.InputEnded:Connect(function(Input : InputObject)
			if Library:Validate(Input.UserInputType) then
				local x = ElementButton
				local f = nil;

				for i=1, #string.split(ElementButton:GetFullName(), '.') do
					x = x.Parent

					pcall(function()
						if x.Visible == false then
							f = true;
							ColorPickerFrame.Visible = false;
						end
					end)
				end

				ColorPickerFrame.Visible = ElementData.Dropped and (not f)
			end
		end)

		ColorPickerFrame.MouseEnter:Connect(function()
			Library.DragAllowed = false;
		end)

		ColorPickerFrame.MouseLeave:Connect(function()
			--Library.DragAllowed = true;
		end)

		ElementData.Float = ColorPickerFrame;

		--TIS(self.ParentGroup.Windows, ColorPickerFrame)
		local Editing = false;

		local AlphaBarValue = 1;
		local HueBarValue = 0;
		local ColorMapValue = { X = 0; Y = 0; }

		local function RepositionColorPicker()
			ColorPickerFrame.Position = UFO(
				ElementButton.AbsolutePosition.X + 2,
				ElementButton.AbsolutePosition.Y + (ElementButton.AbsoluteSize.Y) + 8
			)
		end

		local function GetKeypointValue(sequence: ColorSequence, time: number)
			if time == 0 then
				return sequence.Keypoints[1].Value
			elseif time == 1 then
				return sequence.Keypoints[#sequence.Keypoints].Value
			end

			for i = 1, #sequence.Keypoints - 1 do
				local ThisKeypoint = sequence.Keypoints[i]
				local NextKeypoint = sequence.Keypoints[i + 1]
				if time >= ThisKeypoint.Time and time < NextKeypoint.Time then
					local Alpha = (time - ThisKeypoint.Time) / (NextKeypoint.Time - ThisKeypoint.Time)
					return Color3.new(
						(NextKeypoint.Value.R - ThisKeypoint.Value.R) * Alpha + ThisKeypoint.Value.R,
						(NextKeypoint.Value.G - ThisKeypoint.Value.G) * Alpha + ThisKeypoint.Value.G,
						(NextKeypoint.Value.B - ThisKeypoint.Value.B) * Alpha + ThisKeypoint.Value.B
					)
				end
			end
		end

		local function StringToColor(String : string)
			local ColorData = String:split(',')
			local ColorType = nil;

			if #ColorData == 1 then ColorType = 'Hex' end
			if #ColorData <= 3 then ColorType = 'HSV' end
			if #ColorData >= 4 then ColorType = 'RGBA' end

			for Index, value in ColorData do
				ColorData[Index] = tonumber(value)
			end

			if ColorType == 'Hex' then
				return Color3.fromHex(String), ColorData[2]
			end

			if ColorType == 'RGBA' then
				return RGB(ColorData[1], ColorData[2], ColorData[3]), ColorData[4]
			end
		end

		local function ColorToString(Color : Color3) : string
			local Split = tostring(ElementData.Alpha):split('.')
			local Number = Split[1]
			local Decimal = Split[2]

			return SF('%s, %s, %s, %s', 
				MF(ElementData.Value.R*255),
				MF(ElementData.Value.G*255),
				MF(ElementData.Value.B*255),
				`{Number}{Decimal and `.{Decimal:sub(1,3)}` or ''}`
			)
		end

		local function UpdateColor(HSV, Alpha)
			local PackedHSV = { HSV:ToHSV() }

			Alpha = MC(Alpha or 0, 0, 1)

			ElementData.Value = HSV or ElementData.Value
			ElementData.Alpha = Alpha or ElementData.Alpha

			AlphaBarValue = (1 - AlphaMarker.Position.Y.Scale);
			HueBarValue = HueMarker.Position.Y.Scale;
			ColorMapValue = {
				X = ColorMarker.Position.X.Scale;
				Y = ColorMarker.Position.Y.Scale;
			}

			ElementButton.BackgroundColor3 = ElementData.Value
			ElementButton.BackgroundTransparency = (1-ElementData.Alpha)

			PreviewButton.BackgroundColor3 = ElementData.Value
			Alp.BackgroundColor3 = ElementData.Value
			PreviewButton.BackgroundTransparency = (1-ElementData.Alpha)

			AlphaBar.BackgroundColor3 = ElementData.Value

			local Split = tostring(Alpha):split('.')
			local Number = Split[1]
			local Decimal = Split[2] or ''

			local RGBA = {
				[1] = HSV.R;
				[2] = HSV.G;
				[3] = HSV.B;
			}

			ElementData.Callback(ElementData.Value, ElementData.Alpha)
		end

		local function UpdateColorMap()
			local AbsPos = ColorMap.AbsolutePosition
			local AbsSize = ColorMap.AbsoluteSize

			local RelativeMouseX = MC(((Mouse.X - AbsPos.X) / AbsSize.X), 0, 1)
			local RelativeMouseY = MC(((Mouse.Y - AbsPos.Y) / AbsSize.Y), 0, 1)

			TweenService:Create(
				ColorMarker,
				TI(.2, ES.Quart, ED.Out) ,
				{ 
					Position = UFS(RelativeMouseX, RelativeMouseY), 
					AnchorPoint = V2(RelativeMouseX, RelativeMouseY) 
				}
			):Play();

			local Color = {GetKeypointValue(SaturationGradient.Color, RelativeMouseX):ToHSV()}
			local value = {GetKeypointValue(ValueGradient.Color, RelativeMouseY):ToHSV()}

			ColorMapValue.X = RelativeMouseX
			ColorMapValue.Y = RelativeMouseY

			UpdateColor(HSV(Color[1], Color[2], value[3]), AlphaBarValue)
		end

		local function UpdateMarkers()
			local ColorHSV = { ElementData.Value:ToHSV() }

			ColorMarker.Position = UFS(ColorHSV[2], 1-ColorHSV[3])
			ColorMarker.AnchorPoint = V2(ColorHSV[2], 1-ColorHSV[3])
			SaturationGradient.Color = CS({
				CSK(0, HSV(0,0,1));
				CSK(1, HSV(ColorHSV[1], 1, 1));
			})

			HueMarker.Position = UFS(0.5, 1-(ColorHSV[1]))
			HueMarker.AnchorPoint = V2(0.5, 1-(ColorHSV[1]))

			AlphaMarker.Position = UFS(0.5, (1 - ElementData.Alpha))
			AlphaMarker.AnchorPoint = V2(0.5, (1 - ElementData.Alpha))
		end

		local function UpdateHueBar()
			local AbsPos = HueBar.AbsolutePosition
			local AbsSize = HueBar.AbsoluteSize

			local RelativeMouseX = MC(((Mouse.X - AbsPos.X) / AbsSize.X), 0, 1)
			local RelativeMouseY = MC(((Mouse.Y - AbsPos.Y) / AbsSize.Y), 0, 1)

			TweenService:Create(
				HueMarker, 
				TI(.2, ES.Quart, ED.Out),
				{ Position = UFS(0.5, RelativeMouseY), AnchorPoint = V2(0.5, RelativeMouseY) }
			):Play();

			local Color = GetKeypointValue(HueGradient.Color, RelativeMouseY)

			SaturationGradient.Color = CS({
				CSK(0, HSV(0,0,1));
				CSK(1, Color);
			})

			HueBarValue = RelativeMouseY

			local Color = {GetKeypointValue(SaturationGradient.Color, ColorMapValue.X):ToHSV()}
			local value = {GetKeypointValue(ValueGradient.Color, ColorMapValue.Y):ToHSV()}

			UpdateColor(HSV(Color[1], Color[2], value[3]), AlphaBarValue)
		end

		local function UpdateAlphaBar()
			local AbsPos = AlphaBar.AbsolutePosition
			local AbsSize = AlphaBar.AbsoluteSize

			local RelativeMouseX = MC(((Mouse.X - AbsPos.X) / AbsSize.X), 0, 1)
			local RelativeMouseY = MC(((Mouse.Y - AbsPos.Y) / AbsSize.Y), 0, 1)

			TweenService:Create(
				AlphaMarker,
				TI(.2, ES.Quart, ED.Out),
				{ Position = UFS(0.5, RelativeMouseY), AnchorPoint = V2(0.5, RelativeMouseY) }
			):Play();

			AlphaBarValue = 1 - RelativeMouseY
			local Color = {GetKeypointValue(SaturationGradient.Color, ColorMapValue.X):ToHSV()}
			local value = {GetKeypointValue(ValueGradient.Color, ColorMapValue.Y):ToHSV()}

			UpdateColor(HSV(Color[1], Color[2], value[3]), AlphaBarValue)
		end

		function ElementData:Set(NewValue : any?, Alpha : number)
			local IsColor = typeof(NewValue) == 'Color3' and true or false

			if IsColor then
				UpdateColor(NewValue, Alpha)
				UpdateMarkers()
			elseif not IsColor and typeof(NewValue) == 'string' then
				local Converted = StringToColor(NewValue);
				UpdateColor(RGB(Converted[1], Converted[2], Converted[3]), Converted[4])
				UpdateMarkers()
			end
		end

		ElementButton:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
			RepositionColorPicker()
		end)

		ElementButton.Activated:Connect(function()
			ColorPickerFrame.Visible = not ColorPickerFrame.Visible
			ElementData.Dropped = ColorPickerFrame.Visible

			RepositionColorPicker()
		end)

		InputService.InputBegan:Connect(function(Input)
			if ((Input.UserInputType == UIT.MouseButton1) or (Input.UserInputType == UIT.Touch)) then
				if AlphaBar.GuiState == GS.Press then
					Editing = "AlphaBar"
					Library.DragAllowed = false;
					UpdateAlphaBar()
				end

				if HueBar.GuiState == GS.Press then
					Editing = "HueBar"
					Library.DragAllowed = false;
					UpdateHueBar()
				end

				if ColorMap.GuiState == GS.Press then
					Editing = 'ColorMap'
					Library.DragAllowed = false;
					UpdateColorMap()
				end
			end
		end)

		InputService.InputEnded:Connect(function(Input)
			if ((Input.UserInputType == UIT.MouseButton1) or (Input.UserInputType == UIT.Touch)) then
				if not Editing then
					Library.DragAllowed = true;
				end
				
				Editing = false;

				ElementData.Draggable = false;
			end
		end)

		local Connections = {
			ColorMap = UpdateColorMap;
			AlphaBar = UpdateAlphaBar;
			HueBar = UpdateHueBar;
		}

		InputService.InputChanged:Connect(function(Input)
			if Input.UserInputType == UIT.MouseMovement and Editing then
				Connections[Editing]();
			end
		end)

		InputService.TouchMoved:Connect(function(Input)
			if Input.UserInputType == UIT.Touch and Editing then
				Connections[Editing]();
			end
		end)

		HexInput.FocusLost:Connect(function()
			UpdateColor(Color3.fromHex(HexInput.Text), 1)
			UpdateMarkers();
		end)

		ElementData:Set(ElementData.Value, ElementData.Alpha)
		RepositionColorPicker();

		if ElementData.Flag then Library.Flags[ElementData.Flag] = ElementData end
		return ElementData
	end

	function Library.Elements:AddBind(... : {})
		local ElementData = Library:Overwrite({
			Mode = "Click";
			Instance = nil;
			Value = nil;

			Changed = function() end;
			Callback = function() end;
			Flag = nil;
			active = false;
		}, ... or {})
		setmetatable(ElementData, Library.SubElements)

		local ElementButton = New("TextButton", { LayoutOrder = -999, FontFace = Library.Font.Secondary, Modal = true, BorderColor3 = RGB(0, 0, 0), Text = "...", AutoButtonColor = false, Parent = self.SubContainer, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, TextColor3 = RGB(199, 191, 240), ZIndex = 2, TextSize = 14, BackgroundColor3 = RGB(36, 24, 59), }) :: TextButton
		New("UICorner", { Parent = ElementButton, CornerRadius = UD(0, 3), })
		New("UIStroke", { Thickness = 1.25, Parent = ElementButton, Color = RGB(85, 66, 115), ZIndex = 2, ApplyStrokeMode = ASM.Border, BorderStrokePosition = BSP.Inner, })
		New("UIStroke", { Thickness = 2, Color = RGB(13, 9, 25), Parent = ElementButton, ApplyStrokeMode = ASM.Border, BorderStrokePosition = BSP.Inner, })
		New("UIPadding", { PaddingBottom = UD(0, 1), Parent = ElementButton, PaddingLeft = UD(0, 5), PaddingRight = UD(0, 6), })

		local function gsub(e)
			return tostring(e)
				:gsub('Enum%.KeyCode%.', '')
				:gsub('Enum%.UserInputType%.', '')
				:gsub('ouse', '')
				:gsub('utton', '')
		end

		function ElementData:Set(eeeee : string)
			local Blacklist = {
				'RightSuper',
				'LeftSuper',
				'BackSlash',
				'Backspace',
				'Unknown',
				'Return',
				'Escape',
			}

			if eeeee == nil then
				ElementButton.Text = '?'
				ElementData.Value = nil
				return
			end

			local stripped = gsub(eeeee)

			if TF(Blacklist, stripped) then
				ElementButton.Text = '?'
				ElementData.Value = nil
				return
			end

			ElementButton.Text = gsub(eeeee)
			ElementData.Value = gsub(eeeee) 
		end

		ElementButton.Activated:Connect(function()
			ElementData.Editing = true
			ElementButton.Text = '...'
		end)

		ElementButton.MouseEnter:Connect(function()
			--TweenService:Create(
			--	ElementButton,
			--	TI(.15, ES.Linear, ED.InOut),
			--	{ BackgroundColor3 = Library:EditColor(Library.Theme.Foreground, 7) }
			--):Play();
		end)

		ElementButton.MouseLeave:Connect(function()
			--TweenService:Create(
			--	ElementButton,
			--	TI(.15, ES.Linear, ED.InOut),
			--	{ BackgroundColor3 = Library.Theme.Foreground }
			--):Play();
		end)

		local KeybindBeginTask = InputService.InputBegan:Connect(function(Input, GameProcessedEvent)
			if GameProcessedEvent and not ElementData.Editing then
				return
			end

			if ElementData.Editing then
				ElementData:Set(Input.UserInputType == UIT.Keyboard and gsub(Input.KeyCode) or gsub(Input.UserInputType))
				ElementData.Editing = false;
				return
			end

			if gsub(Input.KeyCode) == ElementData.Value or gsub(Input.UserInputType) == ElementData.Value then
				if ElementData.Mode == 'Hold' then
					ElementData.pressed = true
					ElementData.active = true

					while ElementData.pressed do task.wait()
						local _, CallFailure = pcall(function()
							ElementData.Callback(ElementData.Value)
						end)

						if CallFailure then warn(CallFailure) end
					end
				elseif ElementData.Mode == 'Toggle' then
					ElementData.pressed = not ElementData.pressed
					ElementData.active = ElementData.pressed
					while ElementData.pressed do task.wait()
						local _, CallFailure = pcall(function()
							ElementData.Callback(ElementData.Value)
						end)

						if CallFailure then warn(CallFailure) end
					end
				elseif ElementData.Mode == 'Click' then
					ElementData.active = true
					local _, CallFailure = pcall(function()
						ElementData.Callback(ElementData.Value)
					end)

					if CallFailure then warn(CallFailure) end
				end
			end
		end)

		local KeybindEndTask = InputService.InputEnded:Connect(function(Input, GPE)
			if not GPE then
				if (gsub(Input.KeyCode) == ElementData.Value or gsub(Input.UserInputType) == ElementData.Value) and ElementData.Mode == 'Hold' then
					ElementData.pressed = false
					ElementData.active = false
				end

				if (gsub(Input.KeyCode) == ElementData.Value or gsub(Input.UserInputType) == ElementData.Value) and ElementData.Mode == 'Click' then
					ElementData.active = false
				end
			end
		end)

		ElementData:Set(ElementData.Value)

		if ElementData.Flag then Library.Flags[ElementData.Flag] = ElementData end
		return ElementData
	end

	function Library.Elements:AddGroup(...)
		local Group = Library:Overwrite({
			Name = 'Group';
			Size = UDim2.fromScale(1, 1);
			Side = 'Left';
			Tabs = {}; Elements = {};
		}, ... or {})

		local GroupFrame = New("Frame", { Parent = Group.Side == 'Left' and self.C1 or self.C2, Name = [[GroupFrame]], BorderSizePixel = 0, Size = Group.Size, BorderColor3 = RGB(0, 0, 0), Position = UD2(-0.00349650346, 0, 0, 0), BackgroundColor3 = RGB(47, 32, 74) })
		local Topbar = New("Frame", { Parent = GroupFrame, Name = [[Topbar]], ZIndex = 999, BorderSizePixel = 0, Size = UD2(1, 0, 0, 0), BorderColor3 = RGB(0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = -1, BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })
		local TopLine = New("Frame", { Parent = Topbar, Name = [[TopLine]], AnchorPoint = V2(0.5, 0), ZIndex = 3, BorderSizePixel = 0, Size = UD2(1, 12, 0, 1), BorderColor3 = RGB(0, 0, 0), LayoutOrder = -1, Position = UD2(0.5, 0, 0, 0), BackgroundColor3 = RGB(85, 66, 115) })
		local TopGradient = New("Frame", { Parent = TopLine, Name = [[TopGradient]], ZIndex = 3, BorderSizePixel = 0, Size = UD2(1, 0, 0, 12), BorderColor3 = RGB(0, 0, 0), Position = UD2(0, 0, 0, 4), BackgroundColor3 = RGB(47, 32, 74) })
		local TitleContainer = New("Frame", { Parent = Topbar, Name = [[TitleContainer]], ZIndex = 999, BorderSizePixel = 0, Size = UD2(1, 0, 0, 0), BorderColor3 = RGB(0, 0, 0), BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })
		local TitleMask = New("Frame", { Parent = TitleContainer, Name = [[TitleMask]], ZIndex = 999, BorderSizePixel = 0, BorderColor3 = RGB(0, 0, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = RGB(255, 255, 255) })
		local TitleText = New("TextLabel", { Parent = TitleMask, Name = [[TitleText]], ZIndex = 3, BorderSizePixel = 0, BackgroundColor3 = RGB(255, 255, 255), AnchorPoint = V2(0, 0.5), TextSize = 14, Size = UD2(1, 0, 1, 0), BorderColor3 = RGB(0, 0, 0), Text = Group.Name, FontFace = Library.Font.Secondary, TextColor3 = RGB(255, 255, 255), BackgroundTransparency = 1 })
		local Mask = New("Frame", { Parent = TitleMask, Name = [[Mask]], AnchorPoint = V2(0.5, 0), ZIndex = 2, BorderSizePixel = 0, Size = UD2(1, 12, 0, 2), BorderColor3 = RGB(0, 0, 0), Position = UD2(0.5, 0, 0, -2), BackgroundColor3 = RGB(36, 24, 59) })
		local Mask2 = New("Frame", { Parent = TitleMask, Name = [[Mask]], AnchorPoint = V2(0.5, 0), ZIndex = 2, BorderSizePixel = 0, Size = UD2(1, 12, 0, 2), BorderColor3 = RGB(0, 0, 0), Position = UD2(0.5, 0, 0, 0), BackgroundColor3 = RGB(47, 32, 74),} )
		local GroupTabs = New("Frame", { Parent = Topbar, Name = [[GroupSections]], Visible = false, AnchorPoint = V2(0.5, 0), ZIndex = 3, BorderSizePixel = 0, Size = UD2(1, 44, 0, 22), BorderColor3 = RGB(0, 0, 0), LayoutOrder = -998, Position = UD2(0.5, 0, 0, 0), BackgroundColor3 = RGB(36, 24, 59) })
		local GroupTabButtons = New("Frame", { Parent = GroupTabs, Name = [[Buttons]], ZIndex = 2, BorderSizePixel = 0, Size = UD2(1, 0, 1, 0), BorderColor3 = RGB(0, 0, 0), BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })
		local GroupSectionMask = New("Frame", { Parent = GroupTabs, Name = [[GroupSectionMask]], BorderSizePixel = 0, Size = UD2(1, 0, 0, 3), BorderColor3 = RGB(0, 0, 0), Position = UD2(0, 0, 0, -1), BackgroundColor3 = RGB(36, 24, 59) })
		local BottomBar = New("Frame", { Parent = GroupFrame, Name = [[BottomBar]], LayoutOrder =999; BorderSizePixel = 0, Size = UD2(1, 0, 0, 0), BorderColor3 = RGB(0, 0, 0), BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })
		local BottomLine = New("Frame", { Parent = BottomBar, Name = [[BottomLine]], AnchorPoint = V2(0.5, 1), ZIndex = 3, BorderSizePixel = 0, Size = UD2(1, -6, 0, 1), BorderColor3 = RGB(0, 0, 0), Position = UD2(0.5, 0, 1, 0), BackgroundColor3 = RGB(85, 66, 115) })
		local BottomGradient = New("Frame", { Parent = BottomBar, Name = [[BottomGradient]], AnchorPoint = V2(0, 1), ZIndex = 3, BorderSizePixel = 0, Size = UD2(1, -12, 0, 12), BorderColor3 = RGB(0, 0, 0), Position = UD2(0, 0, 1, -4), BackgroundColor3 = RGB(47, 32, 74) })
		New("UIStroke", { Parent = GroupFrame, BorderOffset = UD(0, 0), Color = RGB(85, 66, 115), BorderStrokePosition = BSP.Inner })
		New("UIStroke", { Parent = GroupFrame, BorderOffset = UD(0, 0), Color = RGB(22, 18, 44),} )
		New("UICorner", { Parent = GroupFrame, CornerRadius = UD(0, 2) })
		New("UIPadding", { Parent = GroupFrame, PaddingRight = UD(0, 6), PaddingLeft = UD(0, 6) })
		New("UIGradient", { Parent = TopGradient, Transparency = NS({ NSK(0, 0, 0); NSK(1, 1, 0);}), Rotation = 90 })
		New("UICorner", { Parent = TopGradient, CornerRadius = UD(0, 2),} )
		New("UIListLayout", { Parent = Topbar, HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = SO.LayoutOrder })
		New("UIPadding", { Parent = Topbar, PaddingRight = UD(0, 16), PaddingLeft = UD(0, 16),} )
		New("UIStroke", { Parent = TitleText, BorderOffset = UD(0, 0), BorderStrokePosition = BSP.Inner,} )
		New("UIPadding", { Parent = TitleText, PaddingRight = UD(0, 4), PaddingLeft = UD(0, 4), PaddingBottom = UD(0, 1),} )
		New("UIPadding", { Parent = GroupTabButtons,} )
		New("UIListLayout", { Parent = GroupTabButtons, FillDirection = FD.Horizontal, HorizontalFlex = UFA.Fill, SortOrder = SO.LayoutOrder, Padding = UD(0, 4),} )
		New("UIListLayout", { Parent = GroupFrame, HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = SO.LayoutOrder, Padding = UD(0, 4), VerticalFlex = UFA.Fill,} )
		New("UIGradient", { Parent = BottomGradient, Transparency = NS({ NSK(0, 0, 0); NSK(1, 1, 0);}), Rotation = -90,} )
		New("UICorner", { Parent = BottomGradient, CornerRadius = UD(0, 2),} )

		local DefaultTab = New("ScrollingFrame", { Parent = GroupFrame, Name = [[de]], Active = true, ZIndex = -6, BorderSizePixel = 0, CanvasSize = UD2(0, 0, 0, 0), BackgroundColor3 = RGB(255, 255, 255), Size = UD2(1, 0, 1, 0), ScrollBarImageColor3 = RGB(85, 66, 115), AutomaticCanvasSize = Enum.AutomaticSize.Y, BorderColor3 = RGB(0, 0, 0), ScrollBarThickness = 6, BackgroundTransparency = 1 })
		New("UIListLayout", { Parent = DefaultTab, SortOrder = SO.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center; Padding = UD(0, 8) })
		New("UIPadding", { Parent = DefaultTab, PaddingTop = UD(0, 16), PaddingRight = UD(0, 32), PaddingLeft = UD(0, 32), PaddingBottom = UD(0, 16) })

		function Group:AddTab(name : string)
			local GroupTab = { Elements = {}; };

			TitleContainer.Visible = false;
			GroupTabs.Visible = true;

			if DefaultTab then
				DefaultTab:Destroy()
				DefaultTab = nil;
			end

			local GroupTabButton = New("TextButton", { Parent = GroupTabButtons, Name = [[GroupTabButton]], ZIndex = 2, BorderSizePixel = 0, AutoButtonColor = false, BackgroundColor3 = RGB(36, 24, 59), TextSize = 14, Size = UD2(1, 0, 1, 0), LayoutOrder = 1, BorderColor3 = RGB(0, 0, 0), Text = name, FontFace = Library.Font.Secondary, TextColor3 = RGB(199, 191, 240) })
			local BottomMask = New("Frame", { Parent = GroupTabButton, Name = [[BottomMask]], ZIndex = 999; AnchorPoint = V2(0.5, 1), BorderSizePixel = 0, Size = UD2(1, -2, 0, 2), BorderColor3 = RGB(0, 0, 0), Position = UD2(0.5, 0, 1, 0), BackgroundColor3 = RGB(36, 24, 59) })
			local Filler = New("Frame", { Parent = GroupTabButton, Name = [[Filler]], AnchorPoint = V2(0, 1), ZIndex = 0, BorderSizePixel = 0, Size = UD2(0, 1, 0, 6), BorderColor3 = RGB(0, 0, 0), Position = UD2(0, 0, 1, 1), BackgroundColor3 = RGB(85, 66, 115) })
			local Filler2 = New("Frame", { Parent = GroupTabButton, Name = [[Filler]], AnchorPoint = V2(1, 1), ZIndex = 0, BorderSizePixel = 0, Size = UD2(0, 1, 0, 3), BorderColor3 = RGB(0, 0, 0), Position = UD2(1, 0, 1, 1), BackgroundColor3 = RGB(85, 66, 115),} )
			local Filler3 = New("Frame", { Parent = GroupTabButton, Name = [[Filler]], AnchorPoint = V2(0, 1), ZIndex = 0, BorderSizePixel = 0, Size = UD2(0, 1, 0, 6), BorderColor3 = RGB(0, 0, 0), Position = UD2(0, -1, 1, 0), BackgroundColor3 = RGB(22, 18, 44),} )
			local BottomLine = New("Frame", { Parent = GroupTabButton, Name = [[BottomLine]], AnchorPoint = V2(0.5, 1), ZIndex = 0, BorderSizePixel = 0, Size = UD2(1, 0, 0, 1), BorderColor3 = RGB(0, 0, 0), Position = UD2(0.5, 0, 1, 1), BackgroundColor3 = RGB(85, 66, 115) })
			New("UIStroke", { Parent = GroupTabButton, BorderOffset = UD(0, 0), Color = RGB(22, 18, 44), ApplyStrokeMode = ASM.Border })
			New("UIStroke", { Parent = GroupTabButton, BorderOffset = UD(0, 0), Color = RGB(85, 66, 115), ApplyStrokeMode = ASM.Border, BorderStrokePosition = BSP.Inner,} )
			New("UIStroke", { Parent = GroupTabButton, BorderOffset = UD(0, 0), BorderStrokePosition = BSP.Inner,} )
			New("UICorner", { Parent = GroupTabButton, CornerRadius = UD(0, 2) })

			local GroupTabFrame = New("ScrollingFrame", { Visible = false; Parent = GroupFrame, Name = [[GroupContent]], Active = true, ZIndex = -6, BorderSizePixel = 0, CanvasSize = UD2(0, 0, 0, 0), BackgroundColor3 = RGB(255, 255, 255), Size = UD2(1, 0, 1, 0), ScrollBarImageColor3 = RGB(85, 66, 115), AutomaticCanvasSize = Enum.AutomaticSize.Y, BorderColor3 = RGB(0, 0, 0), ScrollBarThickness = 6, BackgroundTransparency = 1 })
			New("UIListLayout", { Parent = GroupTabFrame, SortOrder = SO.LayoutOrder, Padding = UD(0, 8) })
			New("UIPadding", { Parent = GroupTabFrame, PaddingTop = UD(0, 12), PaddingRight = UD(0, 34), PaddingLeft = UD(0, 10), PaddingBottom = UD(0, 12) })

			if #Group.Tabs == 0 then
				Group.Container = GroupTabFrame
			end

			GroupTabButton.Activated:Connect(function()
				GroupTab:Open();
			end)

			function GroupTab:Open()
				for _, o in next, Group.Tabs do
					o:Close();
				end

				GroupTabButton.BackgroundColor3 = RGB(47, 32, 74)
				BottomMask.BackgroundColor3 = RGB(47, 32, 74)
				BottomMask.Position = UD2(.5, 0, 1, 1)

				GroupTabFrame.Visible = true;
			end

			function GroupTab:Close()
				GroupTabButton.BackgroundColor3 = RGB(36, 24, 59)
				BottomMask.BackgroundColor3 = RGB(36, 24, 59)
				BottomMask.Position = UDim2.fromScale(.5, 1)

				GroupTabFrame.Visible = false;
			end

			if #Group.Tabs == 0 then
				GroupTab:Open();
			end

			GroupTab.Container = GroupTabFrame
			setmetatable(GroupTab, Library.Elements);
			table.insert(Group.Tabs, GroupTab)
			return GroupTab
		end

		Group.Container = DefaultTab
		setmetatable(Group, Library.Elements);
		return Group
	end

	function Library.Elements:AddToggle(... : {})
		local ElementData = Library:Overwrite({
			Text = 'Toggle';
			Value = false;
			Callback = function()
			end,
			doomdtw = true;
		}, ... or {})
		
		self.Children = true;

		local ElementFrame = New("Frame", { Parent = self.Container, Name = [[dxd]], BorderSizePixel = 0, Size = UD2(1, 48, 0, 0), BorderColor3 = RGB(0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })
		local ContainerFrame = New("Frame", { Parent = ElementFrame, Visible = ElementData.Value; Name = [[Container]], BackgroundTransparency = 1; AutomaticSize = Enum.AutomaticSize.Y; BorderSizePixel = 0, Size = UD2(1, 0, 0, 0), BorderColor3 = RGB(0, 0, 0), LayoutOrder = 2, BackgroundColor3 = RGB(255, 255, 255) })
		local ContentFrame = New("Frame", { Parent = ElementFrame, Name = [[Content]], BorderSizePixel = 0, Size = UD2(1, 0, 0, 16), BorderColor3 = RGB(0, 0, 0), BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })
		local ElementLabel = New("TextLabel", { Parent = ContentFrame, Name = [[ElementLabel]], ZIndex = 2, BorderSizePixel = 0, BackgroundColor3 = RGB(255, 255, 255), TextSize = 14, Size = UD2(0.75, -16, 1, 0), TextXAlignment = Enum.TextXAlignment.Left, BorderColor3 = RGB(0, 0, 0), Text = ElementData.Text, FontFace = Library.Font.Secondary, TextColor3 = RGB(255, 255, 255), BackgroundTransparency = 1 })
		local ElementButton = New("TextButton", { Parent = ContentFrame, Name = [[ElementButton]], ZIndex = 2, BorderSizePixel = 0, AutoButtonColor = false, BackgroundColor3 = RGB(36, 24, 59), TextSize = 14, Size = UD2(1, 0, 1, 0), LayoutOrder = -999, BorderColor3 = RGB(0, 0, 0), Text = [[]], FontFace = Library.Font.Primary, TextColor3 = RGB(0, 0, 0) })
		local ElementFill = New("Frame", { Parent = ElementButton, Name = [[ElementFill]], Visible = false, BorderSizePixel = 0, Size = UD2(1, 0, 1, 0), BorderColor3 = RGB(0, 0, 0), BackgroundColor3 = RGB(255, 255, 255) })
		local ImageLabel = New("ImageLabel", { Parent = ElementFill, Image = [[rbxassetid://85882259026421]], BorderSizePixel = 0, Size = UD2(1, 0, 1, 0), BorderColor3 = RGB(0, 0, 0), BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })
		local SubElementContainer = New("Frame", { Parent = ContentFrame, Name = [[SubElementContainer]], AnchorPoint = V2(1, 0), BorderSizePixel = 0, Size = UD2(0.25, -16, 1, 0), BorderColor3 = RGB(0, 0, 0), LayoutOrder = 999, BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })
		New("UIGradient", { Parent = ElementFill, Rotation = 45, Color = CS({ CSK(0, RGB(255, 101.00000157952309, 67.00000360608101)); CSK(1, RGB(255, 61.00000016391277, 103.0000014603138));}) })
		New("UIAspectRatioConstraint", { Parent = ElementButton })
		New("UICorner", { Parent = ElementButton, CornerRadius = UD(0, 3) })
		New("UICorner", { Parent = ElementFill, CornerRadius = UD(0, 2),} )
		New("UIPadding", { Parent = ContainerFrame, PaddingLeft = UD(0, 24); PaddingRight = UD(0, 24) })
		New("UIPadding", { Parent = ElementLabel, PaddingBottom = UD(0, 2),} )
		New("UIStroke", { Parent = ElementLabel, BorderOffset = UD(0, 0), BorderStrokePosition = BSP.Inner })
		New("UIStroke", { Parent = ElementButton, BorderOffset = UD(0, 0), Color = RGB(85, 66, 115), ApplyStrokeMode = ASM.Border, Thickness = 1.25, ZIndex = 2, BorderStrokePosition = BSP.Inner,} )
		New("UIStroke", { Parent = ElementButton, BorderOffset = UD(0, 0), Color = RGB(13, 9, 25), ApplyStrokeMode = ASM.Border, Thickness = 2, BorderStrokePosition = BSP.Inner,} )
		New("UIListLayout", { Parent = ElementFrame, SortOrder = SO.LayoutOrder, Padding = UD(0, 8) })
		New("UIListLayout", { Parent = ContainerFrame, SortOrder = SO.LayoutOrder, Padding = UD(0, 8),} )
		New("UIListLayout", { Parent = ContentFrame, FillDirection = FD.Horizontal, SortOrder = SO.LayoutOrder, Padding = UD(0, 8),} )
		New("UIListLayout", { Parent = SubElementContainer, FillDirection = FD.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UD(0, 2),} )
		New("UIPadding", { PaddingRight = UD(0, 23), Parent = SubElementContainer, })
		
		if self.doomdtw then
			ElementLabel.TextColor3 = RGB(199, 191, 240)
		end
		
		function ElementData:Set(Value : boolean)
			if ElementData.Children then
				ContainerFrame.Visible = Value;
			end
			
			ElementFill.Visible = Value;
			ElementData.Value = Value;
			ElementData.Callback(Value);
		end

		ElementButton.Activated:Connect(function()
			ElementData:Set(not ElementData.Value);
		end)

		ElementButton.MouseEnter:Connect(function()
			ElementButton.BackgroundColor3 = Library:EditColor(RGB(36, 24, 59), 35)
		end)

		ElementButton.MouseLeave:Connect(function()
			ElementButton.BackgroundColor3 = RGB(36, 24, 59)
		end)

		ElementButton.MouseButton1Down:Connect(function()
			ElementButton.BackgroundColor3 = Library:EditColor(RGB(36, 24, 59), 75)
		end)

		ElementButton.MouseButton1Up:Connect(function()
			ElementButton.BackgroundColor3 = Library:EditColor(RGB(36, 24, 59), 25)
		end)

		ElementData:Set(ElementData.Value);

		ElementData.Container = ContainerFrame
		ElementData.SubContainer = SubElementContainer
		setmetatable(ElementData, Library.SubElements);
		setmetatable(ElementData, Library.Elements);
		return ElementData
	end

	function Library.Elements:AddDropdown(... : {})
		local ElementData = Library:Overwrite({
			Text = 'Dropdown';
			Options = {};
			Value = {};
			Callback = function() end;
			Multi = false;
			Float = nil;
		}, ... or {})
		
		self.Children = true;

		local ElementFrame = New("Frame", { Parent = self.Container, Name = [[ElementFrame]], BorderSizePixel = 0, Size = UD2(1, 0, 0, 50), BorderColor3 = RGB(0, 0, 0), BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })
		local ElementLabel = New("TextLabel", { Parent = ElementFrame, Name = [[ElementLabel]], ZIndex = 2, BorderSizePixel = 0, BackgroundColor3 = RGB(255, 255, 255), TextSize = 14, Size = UD2(0.75, -16, 0, 12), TextXAlignment = Enum.TextXAlignment.Left, BorderColor3 = RGB(0, 0, 0), Text = ElementData.Text, FontFace = Library.Font.Secondary, TextColor3 = RGB(255, 255, 255), BackgroundTransparency = 1 })
		local UIListLayout = New("UIListLayout", { Parent = ElementFrame, VerticalAlignment = VA.Center, SortOrder = SO.LayoutOrder, Padding = UD(0, 8), VerticalFlex = UFA.Fill })
		local ElementButton = New("TextButton", { Parent = ElementFrame, Name = [[ElementButton]], BorderSizePixel = 0, AutoButtonColor = false, BackgroundColor3 = RGB(36, 24, 59), TextSize = 14, Size = UD2(1, 0, 0.75, 0), BorderColor3 = RGB(0, 0, 0), Text = [[]], FontFace = Library.Font.Primary, TextColor3 = RGB(0, 0, 0) })
		local OptionLabel = New("TextLabel", { Parent = ElementButton, Name = [[OptionLabel]], ZIndex = 2, BorderSizePixel = 0, BackgroundColor3 = RGB(255, 255, 255), AnchorPoint = V2(0, 0.5), TextSize = 14, Size = UD2(0.75, -16, 0.5, 0), TextXAlignment = Enum.TextXAlignment.Left, BorderColor3 = RGB(0, 0, 0), Text = [[None]], FontFace = Library.Font.Secondary, Position = UD2(0, 0, 0.5, 0), TextColor3 = RGB(199, 191, 240), BackgroundTransparency = 1 })
		local ImageLabel = New("ImageLabel", { Parent = ElementButton, AnchorPoint = V2(1, 0.5), Image = [[rbxassetid://16747905322]], BorderSizePixel = 0, Size = UD2(0, 8, 0, 8), BorderColor3 = RGB(0, 0, 0), ImageColor3 = RGB(199, 191, 240), Position = UD2(1, 0, 0.5, 0), BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })
		New("UIAspectRatioConstraint", { Parent = ImageLabel })
		New("UICorner", { Parent = ElementButton, CornerRadius = UD(0, 3) })
		New("UIPadding", { Parent = ElementLabel, PaddingBottom = UD(0, 2) })
		New("UIPadding", { Parent = OptionLabel,} )
		New("UIPadding", { Parent = ElementButton, PaddingRight = UD(0, 12), PaddingLeft = UD(0, 8),} )
		New("UIPadding", { Parent = ElementFrame, PaddingTop = UD(0, 2), PaddingBottom = UD(0, 2),} )
		New("UIStroke", { Parent = ElementLabel, BorderOffset = UD(0, 0), BorderStrokePosition = BSP.Inner })
		New("UIStroke", { Parent = ElementButton, BorderOffset = UD(0, 0), Color = RGB(13, 9, 25), ApplyStrokeMode = ASM.Border, BorderStrokePosition = BSP.Inner,} )
		New("UIStroke", { Parent = ElementButton, BorderOffset = UD(0, 0), Color = RGB(85, 66, 115), ApplyStrokeMode = ASM.Border, Thickness = 1.25,} )
		New("UIStroke", { Parent = OptionLabel, Enabled = false, BorderOffset = UD(0, 0), BorderStrokePosition = BSP.Inner,} )
		New("UIStroke", { Parent = OptionLabel, BorderOffset = UD(0, 0), Transparency = 0.25,} )
		
		if self.doomdtw then
			ElementLabel.TextColor3 = RGB(199, 191, 240)
		end
		
		local OptionFrame = New("Frame", { Parent = Library.Instance, Name = [[OptionFrame]], Visible = false, ZIndex = 2, BorderSizePixel = 0, Size = UD2(0, 254, 0, 0), BorderColor3 = RGB(0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UD2(0.650589406, 0, 0.420182556, 0), BackgroundColor3 = RGB(36, 24, 59) })
		New("UIStroke", { Parent = OptionFrame, Enabled = false, BorderOffset = UD(0, 0), Color = RGB(29, 19, 53), BorderStrokePosition = BSP.Inner })
		New("UIStroke", { Parent = OptionFrame, BorderOffset = UD(0, 0), Color = RGB(85, 66, 115),} )
		New("UICorner", { Parent = OptionFrame, CornerRadius = UD(0, 2) })
		New("UIPadding", { Parent = OptionFrame })
		New("UIListLayout", { Parent = OptionFrame, SortOrder = SO.LayoutOrder, VerticalFlex = UFA.Fill })

		InputService.InputEnded:Connect(function(Input : InputObject)
			if Library:Validate(Input.UserInputType) then
				local x = ElementButton
				local f = nil;

				for i=1, #string.split(ElementButton:GetFullName(), '.') do
					x = x.Parent

					pcall(function()
						if x.Visible == false then
							f = true;
							OptionFrame.Visible = false;
						end
					end)
				end

				OptionFrame.Visible = ElementData.Dropped and (not f)
			end
		end)

		local function RepositionDropdown()
			OptionFrame.Size = UFO(
				ElementButton.AbsoluteSize.X, 
				(#ElementData.Options <= 3) and #ElementData.Options * 32 or 96
			)

			OptionFrame.Position = UFO(
				ElementButton.AbsolutePosition.X + 1,
				ElementButton.AbsolutePosition.Y + (ElementButton.AbsoluteSize.Y)
			)
		end

		ElementButton.Changed:Connect(function(Property)
			if Property == 'AbsolutePosition' then
				RepositionDropdown();
			end
		end)

		local function PopulateDropdown()
			for _, __ in OptionFrame:GetChildren() do
				if __:IsA('TextButton') then __:Destroy() end
			end

			for Index, Option in ElementData.Options do
				local OptionButton = New("TextButton", { Parent = OptionFrame, Name = [[OptionButton]], BackgroundTransparency = 1; TextWrapped = true, BorderSizePixel = 0, AutoButtonColor = false, BackgroundColor3 = RGB(54, 38, 94), TextSize = 14, Size = UD2(1, 0, 0, 24), TextXAlignment = Enum.TextXAlignment.Left, BorderColor3 = RGB(0, 0, 0), Text = Option, FontFace = Library.Font.Secondary, TextColor3 = RGB(199, 191, 240) })
				local UIPadding = New("UIPadding", { Parent = OptionButton, PaddingLeft = UD(0, 8) })
				local UIStroke = New("UIStroke", { Parent = OptionButton, BorderOffset = UD(0, 0), Transparency = 0.25 })

				if TF(ElementData.Value, Option) then
					OptionButton.BackgroundTransparency = 0.5;
					--OptionButton.TextColor3 = Library.Theme.PrimaryAccent
				end

				OptionButton.MouseEnter:Connect(function()
					OptionButton.BackgroundTransparency = OptionButton.BackgroundTransparency == 0 and 0 or .5;
				end)

				OptionButton.MouseLeave:Connect(function()
					OptionButton.BackgroundTransparency = OptionButton.BackgroundTransparency == 0 and 0 or 1;
				end)

				OptionButton.Activated:Connect(function()
					if ElementData.Multi == false then
						ElementData.Value = {[1] = Option}
					elseif ElementData.Multi == true then
						if TF(ElementData.Value, Option) then
							for i, __ in ElementData.Value do
								if __ == Option then
									TR(ElementData.Value, i)
								end
							end
						else
							TIS(ElementData.Value, Option)
						end
					end

					ElementData:Set(ElementData.Value)
				end)
			end
		end

		ElementButton.MouseEnter:Connect(function()
		end)

		ElementButton.MouseLeave:Connect(function()

		end)

		function ElementData:Set(Value : {})
			if Value == nil then
				ElementData.Value = {[1] = nil}
				OptionLabel.Text = 'none'
			end

			if #ElementData.Value > 0 then
				OptionLabel.Text = TCC(ElementData.Value, ', ')
			elseif #ElementData.Value <= 0 then
				OptionLabel.Text = 'none'
			end

			for _, OptionButton in OptionFrame:GetChildren() do
				if OptionButton:IsA('TextButton') then
					OptionButton:SetAttribute('Accent', nil)
					OptionButton:SetAttribute('Text', 'TextColor3:-75')
					OptionButton.BackgroundTransparency = 1

					if TF(ElementData.Value, OptionButton.Text) then
						OptionButton.BackgroundTransparency = 0
						--OptionButton.TextColor3 = Library.Theme.PrimaryAccent
						OptionButton:SetAttribute('Selected', true)
						OptionButton:SetAttribute('Accent', 'TextColor3')
						OptionButton:SetAttribute('Text', nil)
					end
				end
			end

			if not Value then return end

			for i,v in Value do
				if TF(ElementData.Options, v) then
					ElementData.Value[i] = v
					OptionLabel.Text = TCC(ElementData.Value, ', ')
				end
			end

			local _, CallFailure = pcall(function()
				ElementData.Callback(ElementData.Value)
			end)

			if CallFailure then warn(CallFailure) end
		end

		function ElementData:UpdateList(NewList : {})
			ElementData.Options = NewList
			PopulateDropdown()
		end

		PopulateDropdown()

		ElementButton.Activated:Connect(function()
			OptionFrame.Visible = not OptionFrame.Visible
			ElementData.Dropped = OptionFrame.Visible

			if OptionFrame.Visible then
				OptionFrame:AddTag('Visible')
			else
				OptionFrame:RemoveTag('Visible')
			end

			RepositionDropdown()
		end)

		ElementData:Set(ElementData.Value)
		if ElementData.Flag then 
			Library.Flags[ElementData.Flag] = ElementData 
		end

		return ElementData	
	end
	
	function Library.Elements:AddSearchList(... : {})
		local ElementData = Library:Overwrite({
			Text = 'Search List';
			Options = {};
			Buttons = {};
			Value = {};
			Callback = function() end;
			Multi = false;
		}, ... or {})
		
		local ElementFrame = New("Frame", { Name = "Search List", Parent = self.Container, BorderColor3 = RGB(0, 0, 0), Size = UD2(1, self.doomdtw and 0 or 48, self.doomdtw and .5 or 1, -32), BorderSizePixel = 0, BackgroundColor3 = RGB(36, 24, 59), }) :: Frame
		local SearchBar = New("Frame", { Parent = ElementFrame, BorderColor3 = RGB(0, 0, 0), Size = UD2(1, 0, 0, 24), BorderSizePixel = 0, BackgroundColor3 = RGB(29, 19, 53), }) :: Frame
		local SearchInput = New("TextBox", { Name = 'SearchInput'; Parent = SearchBar, FontFace = FN(Library.Font.Primary.Family, FW.Bold, FS.Italic), TextColor3 = RGB(199, 191, 240); PlaceholderColor3 = RGB(199, 191, 240); BorderColor3 = RGB(0, 0, 0), Text = ''; PlaceholderText = "Search...", BorderSizePixel = 0, AnchorPoint = V2(0, 0.5), Size = UD2(0.75, -16, 0.5, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.fromScale(0, 0.5), ZIndex = 2, TextSize = 14, BackgroundColor3 = RGB(255, 255, 255), }) :: TextLabel
		local ListFrame = New("ScrollingFrame", { ScrollBarImageColor3 = RGB(85, 66, 115), CanvasSize = UD2(); AutomaticCanvasSize = Enum.AutomaticSize.Y;	 Active = true, BorderColor3 = RGB(0, 0, 0), ScrollBarThickness = 6, AnchorPoint = V2(0, 1), BackgroundTransparency = 1, Position = UDim2.fromScale(0, 1), Parent = ElementFrame, Size = UD2(1, -6, 1, -24), BorderSizePixel = 0, BackgroundColor3 = RGB(36, 24, 59), }) :: ScrollingFrame
		
		New("UIStroke", { Color = RGB(85, 66, 115), Parent = SearchBar, ApplyStrokeMode = ASM.Border, BorderStrokePosition = BSP.Inner, ZIndex = 2; })
		New("UIStroke", { Color = RGB(22, 18, 44), ApplyStrokeMode = ASM.Border, Parent = SearchBar, BorderStrokePosition = BSP.Inner, ZIndex = 1; Thickness = 2; })
		New("UIStroke", { Color = RGB(85, 66, 115), Parent = ElementFrame, BorderStrokePosition = BSP.Inner, ZIndex = 2; })
		New("UIStroke", { Color = RGB(22, 18, 44), Parent = ElementFrame, BorderStrokePosition = BSP.Inner, Thickness = 2; ZIndex = 1 })
		New("UIStroke", { Enabled = false, Parent = SearchInput, BorderStrokePosition = BSP.Inner, })
		New("UIStroke", { Parent = SearchInput, Transparency = 0.25, })
		New("UICorner", { Parent = ListFrame, CornerRadius = UD(0, 2), })
		New("UICorner", { Parent = SearchBar, CornerRadius = UD(0, 2), })
		New("UICorner", { Parent = ElementFrame, CornerRadius = UD(0, 2), })
		New("UIListLayout", { Parent = ListFrame, SortOrder = SO.LayoutOrder, })
		New("UIPadding", { Parent = ListFrame, PaddingTop = UD(0, 4), })
		New("UIPadding", { PaddingLeft = UD(0, 8), Parent = SearchInput, })
		
		SearchInput:GetPropertyChangedSignal('Text'):Connect(function()
			local Query = SearchInput.Text
			
			for _, Option in ListFrame:GetChildren() do
				if Option:IsA('TextButton') then
					Option.Visible = false;

					if (Option:FindFirstChildOfClass('TextLabel').Text):lower():match(Query:lower()) then
						Option.Visible = true;
					end
				end
			end
		end)
		
		local Proxy = {};
		local Populate = function()
			for _, Child in ListFrame:GetChildren() do
				if Child:IsA('TextButton') then
					Child:Destroy()
				end
			end

			for i, Option in next, Proxy do
				local OptionData = { Selected = false; };

				local OptionButton = New("TextButton", { Name = 'xxxxxx'; Parent = ListFrame, TextWrapped = true, TextColor3 = RGB(255, 255, 255), BorderColor3 = RGB(0, 0, 0), Text = "", AutoButtonColor = false, Size = UD2(1, 0, 0, 24), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0, FontFace = FN("rbxasset://fonts/families/SourceSansPro.json", FW.Bold, FS.Normal), TextSize = 14, BackgroundColor3 = RGB(54, 38, 94), }) :: TextButton
				local OptionLabel = New("TextLabel", { FontFace = Library.Font.Secondary, TextColor3 = (ElementData.Value[1] == Option) and RGB(255, 255, 255) or RGB(199, 191, 240), TextTransparency = (ElementData.Value[1] == Option) and 0 or 0.25; BorderColor3 = RGB(0, 0, 0), Text = Option, Parent = OptionButton, BackgroundTransparency = 1, Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, AutomaticSize = Enum.AutomaticSize.X, TextSize = 14, BackgroundColor3 = RGB(255, 255, 255), }) :: TextLabel
				local Gradient = New("UIGradient", { Enabled = (ElementData.Value[1] == Option); Rotation = 45, Parent = OptionLabel, Color = CS{ CSK(0, RGB(255, 101, 67)), CSK(1, RGB(255, 61, 103))}, })
				New("UIPadding", { PaddingLeft = UD(0, 10), Parent = OptionLabel, })
				New("UIStroke", { Parent = OptionButton, Transparency = 0.25, })
				New("UIStroke", { Parent = OptionButton, Transparency = 0.25, })

				function OptionData:Select()
					OptionData.Selecetd = true;
					if not ElementData.Multi then
						for _, o in next, ElementData.Buttons do
							o:Deselect();
						end
					end

					table.insert(ElementData.Value, Option)
					ElementData.Callback(ElementData.Value)

					OptionData.Selected = not OptionData.Selected;
					Gradient.Enabled = (OptionData.Selected)
					OptionLabel.TextColor3 = OptionData.Selected and HSV(0, 0, 1) or RGB(199, 191, 240)
					OptionLabel.TextTransparency = OptionData.Selected and 0 or 0.25
				end

				function OptionData:Deselect()
					if table.find(ElementData.Value, Option) then
						table.remove(ElementData.Value, table.find(ElementData.Value, Option))
					end
					
					OptionData.Selected = false;

					Gradient.Enabled = (OptionData.Selected)
					OptionLabel.TextColor3 = OptionData.Selected and HSV(0, 0, 1) or RGB(199, 191, 240)
					OptionLabel.TextTransparency = OptionData.Selected and 0 or 0.25
					--ElementData.Callback(ElementData.Value)
				end

				OptionButton.Activated:Connect(function()
					if OptionData.Selected then
						OptionData:Deselect();
					else
						OptionData:Select();
					end
				end)

				table.insert(ElementData.Buttons, OptionData)
			end
		end

		setmetatable(ElementData.Options, {
			__index = Proxy,
			__len = function()
				return #Proxy
			end,
			__call = function()
				return Proxy
			end,
			__newindex = function(t, k, v)
				Proxy[k]=v
				Populate();
			end,
		})
		
		return ElementData
	end
	
	function Library.Elements:AddSlider(... : {})
		local ElementData = Library:Overwrite({
			Text = 'Slider';
			Value = 0;
			Min = 0;
			Max = 100;
			Dec = false;
			Mode = 'Value';
			Decn = 2;
			Prefix = '';
			Suffix = '';
			Callback = function() end;
			Flag = nil;
			Editing = false;
		}, ... or {})
		setmetatable(ElementData, Library.Elements)

		self.Children = true;

		local ElementFrame = New("Frame", { Parent = self.Container, Name = [[ElementFrame]], BorderSizePixel = 0, Size = UD2(1, 0, 0, 28), BorderColor3 = RGB(0, 0, 0), BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })
		local ElementLabel = New("TextLabel", { Parent = ElementFrame, Name = [[ElementLabel]], ZIndex = 2, BorderSizePixel = 0, BackgroundColor3 = RGB(255, 255, 255), TextSize = 14, Size = UD2(0.75, -16, 0.5, 0), TextXAlignment = Enum.TextXAlignment.Left, BorderColor3 = RGB(0, 0, 0), Text = ElementData.Text, FontFace = Library.Font.Secondary, TextColor3 = RGB(255, 255, 255), BackgroundTransparency = 1 })
		local ElementButton = New("TextButton", { Parent = ElementFrame, Name = [[ElementButton]], BorderSizePixel = 0, AutoButtonColor = false, BackgroundColor3 = RGB(36, 24, 59), TextSize = 14, Size = UD2(1, 0, 0.5, 0), BorderColor3 = RGB(0, 0, 0), Text = [[]], FontFace = Library.Font.Primary, TextColor3 = RGB(0, 0, 0) })
		local ElementFill = New("Frame", { Parent = ElementButton, ClipsDescendants = true; Name = [[SliderFill]], ZIndex = 2, BorderSizePixel = 0, Size = UD2(0.5, 0, 1, 0), BorderColor3 = RGB(0, 0, 0), BackgroundColor3 = RGB(255, 255, 255) })
		local ValueLabel = New("TextLabel", { Parent = ElementButton, Name = [[ValueLabel]], ZIndex = 999, BorderSizePixel = 0, BackgroundColor3 = RGB(255, 255, 255), AnchorPoint = V2(0.5, 0.5), TextSize = 14, Size = UD2(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, TextXAlignment = Enum.TextXAlignment.Left, BorderColor3 = RGB(0, 0, 0), Text = ElementData.Value, FontFace = Library.Font.Secondary, Position = UD2(1, 0, 1, 0), TextColor3 = RGB(255, 255, 255), BackgroundTransparency = 1 })
		local FillGradient = New("Frame", { Parent = ElementFill, Name = [[FillGradient]], BorderSizePixel = 0, Size = UD2(0, 100, 1, 0), BorderColor3 = RGB(0, 0, 0), BackgroundColor3 = RGB(255, 255, 255) })
		New("UIGradient", { Parent = FillGradient, Rotation = 0, Color = CS({ CSK(0, RGB(255, 101.00000157952309, 67.00000360608101)); CSK(1, RGB(255, 61.00000016391277, 103.0000014603138));}) })
		New("UIPadding", { Parent = ElementLabel, PaddingBottom = UD(0, 2) })
		New("UIPadding", { Parent = ValueLabel, PaddingBottom = UD(0, 2),} )
		New("UIStroke", { Parent = ElementLabel, BorderOffset = UD(0, 0), BorderStrokePosition = BSP.Inner })
		New("UIStroke", { Parent = ValueLabel, BorderOffset = UD(0, 0), Transparency = 0.25, BorderStrokePosition = BSP.Inner,} )
		New("UIStroke", { Parent = ElementButton, BorderOffset = UD(0, 0), Color = RGB(13, 9, 25), ApplyStrokeMode = ASM.Border, BorderStrokePosition = BSP.Inner,} )
		New("UIStroke", { Parent = ElementButton, BorderOffset = UD(0, 0), Color = RGB(85, 66, 115), ApplyStrokeMode = ASM.Border, Thickness = 1.25,} )
		New("UICorner", { Parent = ElementButton, CornerRadius = UD(0, 3) })
		New("UIPadding", { Parent = ElementFrame, PaddingTop = UD(0, 2), PaddingBottom = UD(0, 2),} )
		New("UIListLayout", { Parent = ElementFrame, VerticalAlignment = VA.Center, SortOrder = SO.LayoutOrder, Padding = UD(0, 8), VerticalFlex = UFA.Fill })
		--New("UIGradient", { Parent = ElementFill, Rotation = 45, Color = CS({ CSK(0, RGB(255, 101.00000157952309, 67.00000360608101)); CSK(1, RGB(255, 61.00000016391277, 103.0000014603138));}) })
		
		if self.doomdtw then
			ElementLabel.TextColor3 = RGB(199, 191, 240)
		end
		
		ElementButton:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
			FillGradient.Size = UD2(0, ElementButton.AbsoluteSize.X, 1, 0)
		end)

		local function UpdateSlider()
			local MouseX = MC(Mouse.X - ElementButton.AbsolutePosition.X, 0, ElementButton.AbsoluteSize.X)
			local Clamped = MC((MouseX / ElementButton.AbsoluteSize.X) * (ElementData.Max - ElementData.Min) + ElementData.Min, ElementData.Min, ElementData.Max)

			ElementData:Set(Clamped)

			local _, CallFailure = pcall(function()
				ElementData.Callback(ElementData.Value)
			end)

			if CallFailure then warn(CallFailure) end
		end

		function ElementData:Set(NewValue : number?)
			ElementData.Value = NewValue
			local Split = tostring(NewValue):split('.')
			local FillMultiple = (NewValue - ElementData.Min) / (ElementData.Max - ElementData.Min)
			ValueLabel.Text = ElementData.Mode == 'Value' and `{ElementData.Prefix}{Split[1]}{ElementData.Dec and Split[2] and `.{Split[2]:sub(1, ElementData.Decn)}` or ''}{ElementData.Suffix}` or `{MF(FillMultiple*100)}%`

			TweenService:Create(
				ValueLabel,
				TI(.25, ES.Quart, ED.Out),
				{ Position = UFS(FillMultiple, 1)}
			):Play();

			TweenService:Create(
				ElementFill,
				TI(.25, ES.Quart, ED.Out),
				{ Size = UFS(FillMultiple, 1)}
			):Play();
		end

		InputService.InputBegan:Connect(function(Input)
			if ((Input.UserInputType == UIT.MouseButton1) or (Input.UserInputType == UIT.Touch)) and ElementButton.GuiState == GS.Press then
				ElementData.Editing = true
				UpdateSlider()
			end
		end)

		InputService.InputEnded:Connect(function(Input)
			if ((Input.UserInputType == UIT.MouseButton1) or (Input.UserInputType == UIT.Touch)) then
				ElementData.Editing = false
			end
		end)

		InputService.InputChanged:Connect(function(Input)
			if Input.UserInputType == UIT.MouseMovement and ElementData.Editing then
				UpdateSlider()
			end
		end)

		InputService.TouchMoved:Connect(function(Input)
			if Input.UserInputType == UIT.Touch and ElementData.Editing then
				UpdateSlider()
			end
		end)

		ElementData:Set(ElementData.Value)
		return ElementData
	end

	function Library.Elements:AddButton(... : {})
		local ElementData = Library:Overwrite({
			Text = 'Button';
			Callback = function() end;
		}, ... or {});

		self.Children = true;

		local ElementButton = New("TextButton", { Parent = self.Container; FontFace = FN("rbxasset://fonts/families/SourceSansPro.json", FW.Regular, FS.Normal), TextColor3 = RGB(0, 0, 0), BorderColor3 = RGB(0, 0, 0), Text = "", AutoButtonColor = true, Size = UD2(1, 0, 0, 30), BorderSizePixel = 0, TextSize = 14, BackgroundColor3 = RGB(67, 48, 104), }) :: TextButton
		local ElementLabel = New("TextLabel", { Parent = ElementButton; FontFace = FN("rbxasset://fonts/families/SourceSansPro.json", FW.Bold, FS.Normal), TextColor3 = RGB(199, 191, 240), BorderColor3 = RGB(0, 0, 0), Text = ElementData.Text or 'nil', AnchorPoint = V2(0, 0.5), BorderSizePixel = 0, BackgroundTransparency = 1, Position = UDim2.fromScale(0, 0.5), Size = UDim2.fromScale(1, 0.5), ZIndex = 2, TextSize = 14, BackgroundColor3 = RGB(255, 255, 255), }) :: TextLabel
		New("UICorner", { Parent = ElementButton, CornerRadius = UD(0, 3), })
		New("UIPadding", { Parent = ElementLabel, })
		New("UIStroke", { Enabled = false, Parent = ElementLabel, BorderStrokePosition = BSP.Inner, })
		New("UIStroke", { Parent = ElementLabel, Transparency = 0.25, })
		New("UIPadding", { Parent = ElementButton, })
		New("UIStroke", { Color = RGB(36, 24, 59), Parent = ElementButton, ApplyStrokeMode = ASM.Border, })

		if self.doomdtw then
			ElementLabel.TextColor3 = RGB(199, 191, 240)
		end
		
		ElementButton.Activated:Connect(ElementData.Call or ElementData.Callback)

		return ElementData;
	end
end

function Library:Window(...)
	local Window = Library:Overwrite({
		name = 'Window';
		size = UDim2.fromOffset(640, 620);
		position = UDim2.fromScale(.5, .5);
		anchor = V2(.5, .5);
		
		Tabs = {};
	}, ... or {})

	local WindowFrame = New("Frame", { Parent = Library.Instance, AnchorPoint = Window.anchor; Size = Window.size; Position = Window.position; BorderSizePixel = 0, BorderColor3 = RGB(0, 0, 0), BackgroundColor3 = RGB(47, 32, 74) })
	local ContentFrame = New("Frame", { Parent = WindowFrame, BorderSizePixel = 0, Size = UD2(1, 0, 1, 0), BorderColor3 = RGB(0, 0, 0), LayoutOrder = 1, BackgroundTransparency = 1, BackgroundColor3 = RGB(29, 19, 53) })
	local TabButtons = New("Frame", { Parent = ContentFrame, BorderSizePixel = 0, Size = UD2(1, 0, 0, 30), BorderColor3 = RGB(0, 0, 0), BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })
	local TitleLabel = New("TextLabel", { Parent = WindowFrame, BorderSizePixel = 0, BackgroundColor3 = RGB(255, 255, 255), AnchorPoint = V2(0, 0.5), TextSize = 14, Size = UD2(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, TextXAlignment = Enum.TextXAlignment.Left, BorderColor3 = RGB(0, 0, 0), Text = Window.name or "doomdtw", FontFace = Library.Font.Secondary, Position = UD2(0, 0, 0.5, 0), TextColor3 = RGB(255, 255, 255), BackgroundTransparency = 1 })
	local Drag = New("UIDragDetector", { Parent = WindowFrame});New("UIListLayout", { Parent = TabButtons, FillDirection = FD.Horizontal, HorizontalFlex = UFA.Fill })
	New("UIListLayout", { Parent = ContentFrame, SortOrder = SO.LayoutOrder })
	New("UIListLayout", { Parent = WindowFrame, SortOrder = SO.LayoutOrder, Padding = UD(0, 8), VerticalFlex = UFA.Fill })
	New("UIStroke", { Parent = ContentFrame, BorderOffset = UD(0, 0), Color = RGB(85, 66, 115) })
	New("UIStroke", { Parent = ContentFrame, BorderOffset = UD(0, 0), Color = RGB(29, 19, 53), BorderStrokePosition = BSP.Inner })
	New("UIStroke", { Parent = TitleLabel })
	New("UIPadding", { Parent = WindowFrame, PaddingTop = UD(0, 10), PaddingRight = UD(0, 10), PaddingLeft = UD(0, 10), PaddingBottom = UD(0, 10) })
	New("UIPadding", { Parent = TitleLabel, PaddingBottom = UD(0, 2) })
	New("UICorner", { Parent = WindowFrame, CornerRadius = UD(0, 2) })

	ContentFrame:GetPropertyChangedSignal('GuiState'):Connect(function()
		if ContentFrame.GuiState == (Enum.GuiState.Hover or Enum.GuiState.Press) then
			Drag.Enabled = false;
		else
			if Library.DragAllowed then
				Drag.Enabled = true;
			end
		end
	end)

	function Window:Toggle(Visibility : boolean)
		WindowFrame.Visible = Visibility;
	end

	function Window:Exit()
		WindowFrame:Destroy();
		Window = nil;
	end

	function Window:AddTab(Name : string) 
		local Tab = { Sections = {}; };

		local TabButton = New("TextButton", { Parent = TabButtons, BorderSizePixel = 0, AutoButtonColor = false, BackgroundColor3 = RGB(29, 19, 53), TextSize = 16, Size = UD2(1, 0, 1, 0), BorderColor3 = RGB(0, 0, 0), Text = Name or "Tab", TextTransparency = 0.25, FontFace = Library.Font.Secondary, TextColor3 = RGB(199, 191, 240) })
		New("UIStroke", { Parent = TabButton, ApplyStrokeMode = ASM.Border, Enabled = false, Color = RGB(12, 10, 25) })
		New("UIStroke", { Parent = TabButton, ApplyStrokeMode = ASM.Border, Color = RGB(85, 66, 115),} )
		New("UIStroke", { Parent = TabButton,} )
		New("UICorner", { Parent = TabButton, CornerRadius = UD(0, 1) })

		local TabFrame = New("Frame", { Parent = ContentFrame, Visible = false; Name = [[TabFrame]], BorderSizePixel = 0, Size = UD2(1, 0, 1, -30), BorderColor3 = RGB(0, 0, 0), BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })
		local SectionButtons = New("Frame", { Parent = TabFrame, Name = [[SectionButtons]], Visible = false, BorderSizePixel = 0, Size = UD2(1, 0, 0, 30), BorderColor3 = RGB(0, 0, 0), LayoutOrder = 2, BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })
		local DefaultSection = New("Frame", { Parent = TabFrame, Name = [[ContentFrame]], BorderSizePixel = 0, Size = UD2(1, 0, 1, -30), BorderColor3 = RGB(0, 0, 0), LayoutOrder = 3, Position = UD2(-0.0811827928, 0, 0.103666626, 0), BackgroundColor3 = RGB(36, 24, 59) })
		local Left = New("Frame", { Parent = DefaultSection, Name = [[Left]], BorderSizePixel = 0, Size = UD2(1, 0, 1, 0), BorderColor3 = RGB(0, 0, 0), BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })
		local Right = New("Frame", { Parent = DefaultSection, Name = [[Right]], BorderSizePixel = 0, Size = UD2(1, 0, 1, 0), BorderColor3 = RGB(0, 0, 0), BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })
		New("UIListLayout", { Parent = SectionButtons, FillDirection = FD.Horizontal, HorizontalFlex = UFA.Fill, VerticalFlex = UFA.Fill })
		New("UIListLayout", { Parent = TabFrame, SortOrder = SO.LayoutOrder, VerticalFlex = UFA.Fill,} )
		New("UIListLayout", { Parent = DefaultSection, FillDirection = FD.Horizontal, HorizontalFlex = UFA.Fill, Padding = UD(0, 16),} )
		New("UIListLayout", { Parent = Left, SortOrder = SO.LayoutOrder, Padding = UD(0, 16), VerticalFlex = UFA.Fill,} )
		New("UIListLayout", { Parent = Right, SortOrder = SO.LayoutOrder, Padding = UD(0, 16), VerticalFlex = UFA.Fill,} )
		New("UIStroke", { Parent = DefaultSection, BorderOffset = UD(0, 0), Color = RGB(85, 66, 115) })
		New("UIStroke", { Parent = DefaultSection, BorderOffset = UD(0, 0), BorderStrokePosition = BSP.Inner, Color = RGB(22, 18, 44) })
		New("UIPadding", { Parent = DefaultSection, PaddingTop = UD(0, 16), PaddingRight = UD(0, 16), PaddingLeft = UD(0, 16), PaddingBottom = UD(0, 16) })
		New("UIStroke", { Parent = SectionButtons, BorderOffset = UD(0, 0), Color = RGB(85, 66, 115) })

		TabButton.Activated:Connect(function()
			Tab:Open()
		end)

		TabButton.MouseEnter:Connect(function()
			TabButton.BackgroundColor3 = Library:EditColor(RGB(47, 32, 74), -10)
		end)

		TabButton.MouseLeave:Connect(function()
			TabButton.BackgroundColor3 = TabFrame.Visible and RGB(47, 32, 74) or RGB(29, 19, 53);
		end)

		function Tab:AddSection(Name : string) 
			local Section = {};

			if DefaultSection then
				DefaultSection:Destroy();
				DefaultSection = nil;

				SectionButtons.Visible = true;
			end

			local SectionFrame = New("Frame", { Parent = TabFrame, Visible = false; Name = [[ContentFrame]], BorderSizePixel = 0, Size = UD2(1, 0, 1, -30), BorderColor3 = RGB(0, 0, 0), LayoutOrder = 3, Position = UD2(-0.0811827928, 0, 0.103666626, 0), BackgroundColor3 = RGB(36, 24, 59) })
			local SectionButton = New("TextButton", { Parent = SectionButtons, BorderSizePixel = 0, AutoButtonColor = false, BackgroundColor3 = RGB(29, 19, 53), TextSize = 16, Size = UD2(1, 0, 1, 0), BorderColor3 = RGB(0, 0, 0), Text = Name or "Section", TextTransparency = 0.25, FontFace = FN('nil', FW.Bold, FS.Normal), Position = UD2(0.430107534, 0, -0.0777777806, 0), TextColor3 = RGB(199, 191, 240) })
			local Left = New("Frame", { Parent = SectionFrame, Name = [[Left]], BorderSizePixel = 0, Size = UD2(1, 0, 1, 0), BorderColor3 = RGB(0, 0, 0), BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })
			local Right = New("Frame", { Parent = SectionFrame, Name = [[Right]], BorderSizePixel = 0, Size = UD2(1, 0, 1, 0), BorderColor3 = RGB(0, 0, 0), BackgroundTransparency = 1, BackgroundColor3 = RGB(255, 255, 255) })
			New("UIListLayout", { Parent = SectionButtons, FillDirection = FD.Horizontal, HorizontalFlex = UFA.Fill, VerticalFlex = UFA.Fill })
			New("UIListLayout", { Parent = TabFrame, SortOrder = SO.LayoutOrder, VerticalFlex = UFA.Fill,} )
			New("UIListLayout", { Parent = SectionFrame, FillDirection = FD.Horizontal, HorizontalFlex = UFA.Fill, Padding = UD(0, 16),} )
			New("UIListLayout", { Parent = Left, SortOrder = SO.LayoutOrder, Padding = UD(0, 16), VerticalFlex = UFA.Fill,} )
			New("UIListLayout", { Parent = Right, SortOrder = SO.LayoutOrder, Padding = UD(0, 16), VerticalFlex = UFA.Fill,} )
			New("UIStroke", { Parent = SectionFrame, BorderOffset = UD(0, 0), Color = RGB(85, 66, 115) })
			New("UIStroke", { Parent = SectionFrame, BorderOffset = UD(0, 0), BorderStrokePosition = BSP.Inner, Color = RGB(22, 18, 44) })
			New("UIPadding", { Parent = SectionFrame, PaddingTop = UD(0, 16), PaddingRight = UD(0, 16), PaddingLeft = UD(0, 16), PaddingBottom = UD(0, 16) })
			New("UIStroke", { Parent = SectionButton, BorderStrokePosition = BSP.Outer; ApplyStrokeMode = ASM.Border, Enabled = false, Color = RGB(12, 10, 25) })
			New("UIStroke", { Parent = SectionButton, ApplyStrokeMode = ASM.Border, Color = RGB(85, 66, 115),} )
			New("UIStroke", { Parent = SectionButton,} )
			New("UICorner", { Parent = SectionButton, CornerRadius = UD(0, 2) })

			SectionButton.Activated:Connect(function()
				Section:Open()
			end)

			SectionButton.MouseEnter:Connect(function()
				SectionButton.BackgroundColor3 = Library:EditColor(RGB(47, 32, 74), -10)
			end)

			SectionButton.MouseLeave:Connect(function()
				SectionButton.BackgroundColor3 = SectionFrame.Visible and RGB(47, 32, 74) or RGB(29, 19, 53);
			end)

			function Section:Open()
				for _, o in Tab.Sections do
					o:Close();
				end

				SectionFrame.Visible = true;
				SectionButton.BackgroundColor3 = RGB(47, 32, 74);
				SectionButton.TextColor3 = RGB(255, 255, 255);
				SectionButton.TextTransparency = 0;
			end

			function Section:Close()
				SectionFrame.Visible = false;
				SectionButton.BackgroundColor3 = RGB(29, 19, 53);
				SectionButton.TextColor3 = RGB(199, 191, 240);
				SectionButton.TextTransparency = .25;
			end

			function Section:Destroy()
				SectionFrame:Destroy();
				SectionButton:Destroy();

				table.remove(Tab.Sections, table.find(Tab.Sections, Section))
			end

			if #Tab.Sections == 0 then
				Section:Open();
			end

			Section.Instance = SectionFrame
			Section.C1 = Left;
			Section.C2 = Right;
			setmetatable(Section, Library.Elements)
			table.insert(Tab.Sections, Section)
			return Section
		end

		function Tab:Open()
			for _, o in Window.Tabs do
				o:Close();
			end

			TabFrame.Visible = true;
			TabButton.BackgroundColor3 = RGB(47, 32, 74);
			TabButton.TextColor3 = RGB(255, 255, 255);
			TabButton.TextTransparency = 0;
		end

		function Tab:Close()
			TabFrame.Visible = false;
			TabButton.BackgroundColor3 = RGB(29, 19, 53);
			TabButton.TextColor3 = RGB(199, 191, 240);
			TabButton.TextTransparency = .25;
		end

		function Tab:Destroy()
			TabFrame:Destroy();
			TabButton:Destroy();

			table.remove(Window.Tabs, table.find(Window.Tabs, Tab))
		end

		if #Window.Tabs == 0 then
			Tab:Open();
		end

		Tab.Instance = TabFrame;
		Tab.C1 = Left;
		Tab.C2 = Right;
		setmetatable(Tab, Library.Elements);
		table.insert(Window.Tabs, Tab)
		return Tab
	end

	table.insert(Library.Windows, Window)
	return Window;
end

return Library
