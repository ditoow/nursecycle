class ScreeningState {
	final bool isLoading;
	final String? error;
	  
	const ScreeningState({
		this.isLoading = false,
		this.error,
	});
	  
	ScreeningState copyWith({
		bool? isLoading,
		String? error,
	}) {
		return ScreeningState(
			isLoading: isLoading ?? this.isLoading,
			error: error ?? this.error,
		);
	}
}
